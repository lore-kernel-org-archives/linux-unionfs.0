Return-Path: <salyzyn@android.com>
Return-Path: <salyzyn@android.com>
Subject: Re: [PATCH v8 2/2] overlayfs: override_creds=off option bypass
 creator_cred
References: <20181106230117.127616-1-salyzyn@android.com>
 <20181106230117.127616-2-salyzyn@android.com>
 <20181108155620.GA3663@redhat.com>
From: Mark Salyzyn <salyzyn@android.com>
Message-ID: <a2796740-acd4-d39d-d78c-1957894fe278@android.com>
Date: Thu, 8 Nov 2018 08:27:00 -0800
MIME-Version: 1.0
In-Reply-To: <20181108155620.GA3663@redhat.com>
Content-Type: multipart/alternative;
 boundary="------------DE98F22DA3F44218B82F65DB"
Content-Language: en-GB
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, "Eric W . Biederman" <ebiederm@xmission.com>, Amir Goldstein <amir73il@gmail.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@android.com
List-ID: <linux-unionfs@vger.kernel.org>

This is a multi-part message in MIME format.
--------------DE98F22DA3F44218B82F65DB
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/08/2018 07:56 AM, Vivek Goyal wrote:
> On Tue, Nov 06, 2018 at 03:01:15PM -0800, Mark Salyzyn wrote:
>> By default, all access to the upper, lower and work directories is the
>> recorded mounter's MAC and DAC credentials.  The incoming accesses are
>> checked against the caller's credentials.
>>
>> If the principles of least privilege are applied, the mounter's
>> credentials might not overlap the credentials of the caller's when
>> accessing the overlayfs filesystem.  For example, a file that a lower
>> DAC privileged caller can execute, is MAC denied to the generally
>> higher DAC privileged mounter, to prevent an attack vector.
>>
>> We add the option to turn off override_creds in the mount options; all
>> subsequent operations after mount on the filesystem will be only the
>> caller's credentials.  The module boolean parameter and mount option
>> override_creds is also added as a presence check for this "feature",
>> existence of /sys/module/overlay/parameters/override_creds.
>>
>> It was not always this way.  Circa 4.4 there was no recorded mounter's
>> credentials, instead privileged access to upper or work directories
>> were temporarily increased to perform the operations.  The MAC
>> (selinux) policies were caller's in all cases.  override_creds=off
>> partially returns us to this older access model minus the insecure
>> temporary credential increases.
>
> So what will have to bunch of overlay operations now which require
> priviliges or additional capabilities. To make all that succeed,
> you will have to give those capabilities to processes accessing
> overlayfs. If yes, I am wondering how is that more secure. IOW,
> having to give these capabilities to all processes accessing
> fs as opposed to giving those capabilities to only mounter.
>
> You also mentioned that you want init to be least priviliged as
> it could be attacked. But now all the processses are priviliged
> and these could be attacked as well.
>
> The way I am looking at it as follows.
>
> - With current model, only mounter needs to have capabilities to
>    do some operations such as whiteout creation etc.
>
> - With override_creds=off, all services accessing overlayfs needs
>    to have increased priviliges.
>
> Is that not increasing attack surface. Previously, you will have to
> attach init and now you can get away by breaking one of the services.
>
> /me is wondering how does that increase security.
>
> Thanks
> Vivek
In Android's case, the only processes that are writing the files are 
themselves privileged, and "they" are actually only one process doing so 
that is not init, and has a non-overlapping set, so well controlled, 
different zones of privilege. The issue is that the privileges of the 
mounter does not allow read, search or execute in a large swath of the 
directories and files as it is not needed or desired, only the processes 
that are granted sepolicy to do so will be allowed in a non-overlapping 
fashion. In a vast majority of the daemons and applications, read only 
and execute only accesses, and executing a file is a transition to a new 
security domain with a completely different set of privileges.

init and others are not allowed to talk to the gpu, keyboard events, 
camera, audio or the keymaster security elements. Most processes are 
not, yet libraries and Hardware Abstraction Layers, and executed daemons 
are. None of this requires the _any_ of the mounter's credentials and 
privileges; yet the files inside the filesystem are.

Think MAC (sepolicy) where every operation is individually labelled, not 
DAC (capabilities or traditional rwxrwxrwx) where privileges are in 
essence a hierarchy of security controls.

Sincerely -- Mark Salyzyn

--------------DE98F22DA3F44218B82F65DB
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <div class="moz-cite-prefix">On 11/08/2018 07:56 AM, Vivek Goyal
      wrote:<br>
    </div>
    <blockquote type="cite" cite="mid:20181108155620.GA3663@redhat.com">
      <pre wrap="">On Tue, Nov 06, 2018 at 03:01:15PM -0800, Mark Salyzyn wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="">By default, all access to the upper, lower and work directories is the
recorded mounter's MAC and DAC credentials.  The incoming accesses are
checked against the caller's credentials.

If the principles of least privilege are applied, the mounter's
credentials might not overlap the credentials of the caller's when
accessing the overlayfs filesystem.  For example, a file that a lower
DAC privileged caller can execute, is MAC denied to the generally
higher DAC privileged mounter, to prevent an attack vector.

We add the option to turn off override_creds in the mount options; all
subsequent operations after mount on the filesystem will be only the
caller's credentials.  The module boolean parameter and mount option
override_creds is also added as a presence check for this "feature",
existence of /sys/module/overlay/parameters/override_creds.

It was not always this way.  Circa 4.4 there was no recorded mounter's
credentials, instead privileged access to upper or work directories
were temporarily increased to perform the operations.  The MAC
(selinux) policies were caller's in all cases.  override_creds=off
partially returns us to this older access model minus the insecure
temporary credential increases.
</pre>
      </blockquote>
      <pre wrap="">

So what will have to bunch of overlay operations now which require
priviliges or additional capabilities. To make all that succeed,
you will have to give those capabilities to processes accessing
overlayfs. If yes, I am wondering how is that more secure. IOW,
having to give these capabilities to all processes accessing
fs as opposed to giving those capabilities to only mounter.

You also mentioned that you want init to be least priviliged as
it could be attacked. But now all the processses are priviliged
and these could be attacked as well.

The way I am looking at it as follows.

- With current model, only mounter needs to have capabilities to
  do some operations such as whiteout creation etc.

- With override_creds=off, all services accessing overlayfs needs
  to have increased priviliges.

Is that not increasing attack surface. Previously, you will have to
attach init and now you can get away by breaking one of the services.

/me is wondering how does that increase security.

Thanks
Vivek
</pre>
    </blockquote>
    <span style="color: rgb(34, 34, 34); font-family: Arial, Helvetica,
      sans-serif; font-size: small; font-style: normal;
      font-variant-ligatures: normal; font-variant-caps: normal;
      font-weight: 400; letter-spacing: normal; orphans: 2; text-align:
      start; text-indent: 0px; text-transform: none; white-space:
      normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width:
      0px; background-color: rgb(255, 255, 255); text-decoration-style:
      initial; text-decoration-color: initial; display: inline
      !important; float: none;">In Android's case, the only processes
      that are writing the files are themselves privileged, and "they"
      are actually only one process doing so that is not init, and has a
      non-overlapping set, so well controlled, different zones of
      privilege. The issue is that the privileges of the mounter does
      not allow read, search or execute in a large swath of the
      directories and files as it is not needed or desired, only the
      processes that are granted sepolicy to do so will be allowed in a
      non-overlapping fashion. In a vast majority of the daemons and
      applications, read only and execute only accesses, and executing a
      file is a transition to a new security domain with a completely
      different set of privileges.<br>
      <br>
      init and others are not allowed to talk to the gpu, keyboard
      events, camera, audio or the keymaster security elements. Most
      processes are not, yet libraries and Hardware Abstraction Layers,
      and executed daemons are. None of this requires the _any_ of the
      mounter's credentials and privileges; yet the files inside the
      filesystem are.<br>
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
      initial;">Think MAC (sepolicy) where every operation is
      individually labelled, not DAC (capabilities or traditional
      rwxrwxrwx) where privileges are in essence a hierarchy of security
      controls.</div>
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
      initial;">Sincerely -- Mark Salyzyn</div>
  </body>
</html>

--------------DE98F22DA3F44218B82F65DB--
