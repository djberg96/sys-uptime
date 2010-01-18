/******************************************************************************
 * uptime.c
 *
 * Authors:
 *    Daniel Berger
 *    Mike Hall
 *
 * sys-uptime source code for most *nix platforms
 *****************************************************************************/
#include <ruby.h>
#include <string.h>
#include <errno.h>

#ifdef HAVE_SYSCTL

#include <sys/sysctl.h>

#ifdef HAVE_SYS_PARAM_H
#include <sys/param.h>
#endif

#ifdef HAVE_SYS_TIME_H
#include <sys/time.h>
#endif

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#else

#include <sys/times.h>
#include <unistd.h>
#include <time.h>

#ifdef HAVE_UTMPX_H
#include <utmpx.h>
#endif

#ifdef _SC_CLK_TCK
#define TICKS sysconf(_SC_CLK_TCK)
#else
#define TICKS sysconf(CLOCKS_PER_SEC)
#endif

#endif

#ifdef HAVE_SYS_LOADAVG_H
#include <sys/loadavg.h>
#endif

#define MAXSTRINGSIZE 32 /* reasonable limit */

#define SYS_UPTIME_VERSION "0.5.3"

VALUE cUptimeError;

unsigned long get_uptime_secs()
{
#ifdef HAVE_SYSCTL
   struct timeval tv;
   size_t tvlen = sizeof(tv);
   int mib[2];

   mib[0] = CTL_KERN;
   mib[1] = KERN_BOOTTIME;

   if(sysctl(mib, 2, &tv, &tvlen, NULL, 0))
      rb_raise(cUptimeError, "sysctl() call failed %s", strerror(errno));

   return time(NULL) - tv.tv_sec;
#else
   struct tms tms;
   unsigned long seconds;
   seconds = times(&tms) / TICKS;

   if(-1 == seconds)
      rb_raise(cUptimeError, "times() function failed: %s", strerror(errno));

   if(seconds < 0)
      rb_raise(cUptimeError, "value returned larger than type could handle");

   return seconds;
#endif
}

/*
 * call-seq:
 *    Uptime.seconds
 *
 * Returns the total number of seconds the system has been up.
 */
static VALUE uptime_seconds()
{
   return UINT2NUM(get_uptime_secs());
}

/*
 * call-seq:
 *    Uptime.minutes
 *
 * Returns the total number of minutes the system has been up.
 */
static VALUE uptime_minutes()
{
   return UINT2NUM(get_uptime_secs() / 60);
}

/*
 * call-seq:
 *    Uptime.hours
 *
 * Returns the total number of hours the system has been up.
 */
static VALUE uptime_hours()
{
   return UINT2NUM(get_uptime_secs() / 3600);
}

/*
 * call-seq:
 *    Uptime.days
 *
 * Returns the total number of days the system has been up.
 */
static VALUE uptime_days()
{
   return UINT2NUM(get_uptime_secs() / 86400);
}

/*
 * call-seq:
 *    Uptime.uptime
 *
 * Calculates and returns the number of days, hours, minutes and
 * seconds the system has been running as a colon-separated string.
 */
static VALUE uptime_uptime()
{
   char c_string[MAXSTRINGSIZE];
   long seconds, days, hours, minutes;

   seconds = get_uptime_secs();
   days = seconds/86400;
   seconds -= days*86400;
   hours = seconds/3600;
   seconds -= hours*3600;
   minutes = seconds/60;
   seconds -= minutes*60;

   sprintf(c_string, "%ld:%ld:%ld:%ld", days, hours, minutes, seconds);

   return rb_str_new2(c_string);
}

/*
 * call-seq:
 *    Uptime.dhms
 *
 * Calculates and returns the number of days, hours, minutes and
 * seconds the system has been running as a four-element Array.
 */
static VALUE uptime_dhms()
{
   VALUE a = rb_ary_new2(4);
   long s, m, h, d;

   s = get_uptime_secs();
   d =  s                / (24*60*60);
   h = (s -= d*24*60*60) / (   60*60);
   m = (s -= h*   60*60) /        60;
   s      -= m*      60;

   rb_ary_push(a, INT2FIX(d));
   rb_ary_push(a, INT2FIX(h));
   rb_ary_push(a, INT2FIX(m));
   rb_ary_push(a, INT2FIX(s));

   return a;
}

/*
 * call-seq:
 *    Uptime.boot_time
 *
 * Returns the boot time as a Time object.
 */
static VALUE uptime_btime(){
   VALUE v_time = Qnil;

#ifdef HAVE_SYSCTL
   struct timeval tv;
   size_t tvlen = sizeof(tv);
   int mib[2];

   mib[0] = CTL_KERN;
   mib[1] = KERN_BOOTTIME;

   if(sysctl(mib, 2, &tv, &tvlen, NULL, 0))
      rb_raise(cUptimeError, "sysctl() call failed: %s", strerror(errno));

   v_time = rb_time_new(tv.tv_sec,tv.tv_usec);
#else
#ifdef HAVE_UTMPX_H
   struct utmpx* ent;

   setutxent();

   while( (ent = getutxent()) ){
      if(ent->ut_type == BOOT_TIME){
         v_time = rb_time_new(ent->ut_tv.tv_sec, ent->ut_tv.tv_usec);
         break;
      }
   }

   endutxent();
#else
   rb_raise(cUptimeError, "boot_time method not implemented on this platform");
#endif
#endif

   return v_time;
}

void Init_uptime()
{
   VALUE mSys, cUptime;

   /* The Sys module only serves as a toplevel namespace */
   mSys = rb_define_module("Sys");

   /* The Uptime encapsulates various bits of uptime information */
   cUptime = rb_define_class_under(mSys, "Uptime", rb_cObject);

   /* The Uptime::Error class is raised if any of the Uptime methods fail */
   cUptimeError = rb_define_class_under(cUptime, "Error", rb_eStandardError);

   /* 0.5.3: The version of this library */
   rb_define_const(cUptime, "VERSION", rb_str_new2(SYS_UPTIME_VERSION));

   /* Singleton Methods */

   rb_define_singleton_method(cUptime, "seconds", uptime_seconds, 0);
   rb_define_singleton_method(cUptime, "minutes", uptime_minutes, 0);
   rb_define_singleton_method(cUptime, "hours",   uptime_hours,   0);
   rb_define_singleton_method(cUptime, "days",    uptime_days,    0);
   rb_define_singleton_method(cUptime, "uptime",  uptime_uptime,  0);
   rb_define_singleton_method(cUptime, "dhms",    uptime_dhms,    0);
   rb_define_singleton_method(cUptime, "boot_time", uptime_btime, 0);
}
