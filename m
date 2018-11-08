Return-Path: <salyzyn@android.com>
Return-Path: <salyzyn@android.com>
Subject: Re: [PATCH v8 2/2] overlayfs: override_creds=off option bypass
 creator_cred
References: <20181106230117.127616-1-salyzyn@android.com>
 <20181106230117.127616-2-salyzyn@android.com>
 <20181108200106.GB3663@redhat.com>
From: Mark Salyzyn <salyzyn@android.com>
Message-ID: <b057da99-adc6-b355-fb57-b314a29f298f@android.com>
Date: Thu, 8 Nov 2018 13:28:32 -0800
MIME-Version: 1.0
In-Reply-To: <20181108200106.GB3663@redhat.com>
Content-Type: multipart/alternative;
 boundary="------------DD46D0D5ED4C802C31A6253C"
Content-Language: en-GB
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, "Eric W . Biederman" <ebiederm@xmission.com>, Amir Goldstein <amir73il@gmail.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@android.com
List-ID: <linux-unionfs@vger.kernel.org>

This is a multi-part message in MIME format.
--------------DD46D0D5ED4C802C31A6253C
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/08/2018 12:01 PM, Vivek Goyal wrote:
> On Tue, Nov 06, 2018 at 03:01:15PM -0800, Mark Salyzyn wrote:
>> By default, all access to the upper, lower and work directories is the
>> recorded mounter's MAC and DAC credentials.  The incoming accesses are
>> checked against the caller's credentials.
> Ok, I am trying to think of scenarios where override_creds=off can
> provide any privilege escalation. How about following.
>
> $ mkdir lower lower/foo upper upper/foo work merged
> $ touch lower/foo/bar.txt
> $ chmod 700 lower/foo/
>
> # Mount overlay with override_creds=off
>
> $ mount -t overlay -o
> lowerdir=lower,upperdir=upper,workdir=work,override_creds=off none merged
>
> # Try to read lower/foo as unpriviliged user. Say "test"
> # su test
> # ls merged/foo/
> ls: cannot access 'merged/foo/': Operation not permitted
>
> # Now first try to do same operation as root and retry as test user.
> $ exit
> $ ls merged/foo
> bar.txt
> $ su test
> $ ls merged/foo
> bar.txt
>
> lower/foo/ is not readable by user "test". So it fails in first try. Later
> "root" accesses it and it populates cache in overlayfs. When test retries,
> it gets these entries from cache.
>
> With override_creds=on this is not a problem because overlay provides
> this as functionality as long as mounter as access to lower/foo/.
>
> But with override_creds=off, mounter is not providing any such
> functionality and we are exposing an issue where cache will make
> something available which is not normally available.
>
> I think it probably is a good idea to do something about it?
>
> Thanks
> Vivek
>
Good stuff.

That sounds like a bug in cache (!) to not recheck caller's credentials. 
Currently unsure how/where to force bypass of the cache (performance 
hit) as it is wired in throughout the code without a clear off switch, 
or rechecking of the credentials at access. This does need to be 
addressed to make this 'feature' more useful/trusted for non-MAC 
controlled, use cases.

This is not a problem in the Android usage case since DAC is simple and 
all can be read, execute bits might be controlled, the owners and perms 
are otherwise unremarkable in the affected arenas that are utilizing 
overlayfs. Not using it for a generic r/w backing except in rooted debug 
scenarios by developers, otherwise everything is r/o, MAC on the other 
hand is complex and heavily inspected. We do, however, want multi level 
security in that both DAC and MAC can be trusted and can protect each 
other from holes.

Sounds like the caveats in the documentation need to be expanded if _no_ 
solution for this kind of access pattern becomes apparent.

-- Mark

--------------DD46D0D5ED4C802C31A6253C
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <div class="moz-cite-prefix">On 11/08/2018 12:01 PM, Vivek Goyal
      wrote:<br>
    </div>
    <blockquote type="cite" cite="mid:20181108200106.GB3663@redhat.com">
      <pre wrap="">On Tue, Nov 06, 2018 at 03:01:15PM -0800, Mark Salyzyn wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="">By default, all access to the upper, lower and work directories is the
recorded mounter's MAC and DAC credentials.  The incoming accesses are
checked against the caller's credentials.
</pre>
      </blockquote>
      <pre wrap="">
Ok, I am trying to think of scenarios where override_creds=off can 
provide any privilege escalation. How about following.

$ mkdir lower lower/foo upper upper/foo work merged
$ touch lower/foo/bar.txt
$ chmod 700 lower/foo/

# Mount overlay with override_creds=off

$ mount -t overlay -o
lowerdir=lower,upperdir=upper,workdir=work,override_creds=off none merged

# Try to read lower/foo as unpriviliged user. Say "test"
# su test
# ls merged/foo/
ls: cannot access 'merged/foo/': Operation not permitted

# Now first try to do same operation as root and retry as test user.
$ exit
$ ls merged/foo
bar.txt
$ su test
$ ls merged/foo
bar.txt

lower/foo/ is not readable by user "test". So it fails in first try. Later
"root" accesses it and it populates cache in overlayfs. When test retries,
it gets these entries from cache.

With override_creds=on this is not a problem because overlay provides
this as functionality as long as mounter as access to lower/foo/.

But with override_creds=off, mounter is not providing any such
functionality and we are exposing an issue where cache will make
something available which is not normally available.

I think it probably is a good idea to do something about it?

Thanks
Vivek

</pre>
    </blockquote>
    Good stuff.<br>
    <br>
    <span style="color: rgb(34, 34, 34); font-family: Arial, Helvetica,
      sans-serif; font-size: small; font-style: normal;
      font-variant-ligatures: normal; font-variant-caps: normal;
      font-weight: 400; letter-spacing: normal; orphans: 2; text-align:
      start; text-indent: 0px; text-transform: none; white-space:
      normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width:
      0px; background-color: rgb(255, 255, 255); text-decoration-style:
      initial; text-decoration-color: initial; display: inline
      !important; float: none;">That sounds like a bug in cache (!) to
      not recheck caller's credentials. Currently unsure how/where to
      force bypass of the cache (performance hit) as it is wired in
      throughout the code without a clear off switch, or rechecking of
      the credentials at access. This does need to be addressed to make
      this 'feature' more useful/trusted for non-MAC controlled, use
      cases.<br>
    </span>
    <div style="color: rgb(34, 34, 34); font-family: Arial, Helvetica,
      sans-serif; font-size: small; font-style: normal;
      font-variant-ligatures: normal; font-variant-caps: normal;
      font-weight: 400; letter-spacing: normal; orphans: 2; text-align:
      start; text-indent: 0px; text-transform: none; white-space:
      normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width:
      0px; text-decoration-style: initial; text-decoration-color:
      initial;"><br>
    </div>
    <div style="color: rgb(34, 34, 34); font-family: Arial, Helvetica,
      sans-serif; font-size: small; font-style: normal;
      font-variant-ligatures: normal; font-variant-caps: normal;
      font-weight: 400; letter-spacing: normal; orphans: 2; text-align:
      start; text-indent: 0px; text-transform: none; white-space:
      normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width:
      0px; text-decoration-style: initial; text-decoration-color:
      initial;">This is not a problem in the Android usage case since
      DAC is simple and all can be read, execute bits might be
      controlled, the owners and perms are otherwise unremarkable in the
      affected arenas that are utilizing overlayfs. Not using it for a
      generic r/w backing except in rooted debug scenarios by
      developers, otherwise everything is r/o, MAC on the other hand is
      complex and heavily inspected. We do, however, want multi level
      security in that both DAC and MAC can be trusted and can protect
      each other from holes.<br>
      <br>
      Sounds like the caveats in the documentation need to be expanded
      if _no_ solution for this kind of access pattern becomes apparent.<br>
      <br>
      -- Mark<br>
    </div>
  </body>
</html>

--------------DD46D0D5ED4C802C31A6253C--
