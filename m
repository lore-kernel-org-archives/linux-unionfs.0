From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] check_layer: Add tests for constant st_dev
Date: Fri, 7 Jul 2017 23:35:01 +0300
Message-ID: <CAOQ4uxhf4-kG8s7WLE_3tsPObiZnCdm+4C07hoFgs=swWTZs4A@mail.gmail.com>
References: <20170704170028.4278-1-chandan@linux.vnet.ibm.com>
 <CAOQ4uxiS9b7GboLpV2-FekiD+uND3Nofiybdr_=w-XcvhH+pkw@mail.gmail.com> <3081705.s7MyyWUpSq@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:35794 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbdGGUfD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Jul 2017 16:35:03 -0400
Received: by mail-yw0-f193.google.com with SMTP id z21so2327238ywz.2
        for <linux-unionfs@vger.kernel.org>; Fri, 07 Jul 2017 13:35:02 -0700 (PDT)
In-Reply-To: <3081705.s7MyyWUpSq@localhost.localdomain>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Jul 7, 2017 at 8:36 AM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> On Tuesday, July 4, 2017 11:33:57 PM IST Amir Goldstein wrote:
>> On Tue, Jul 4, 2017 at 8:00 PM, Chandan Rajendra
>> <chandan@linux.vnet.ibm.com> wrote:
>> > With constant st_dev implemented, overlayfs never returns the real dev
>> > corresponding to lowerdir filesystems. Also, for the samefs case,
>> > overlayfs always returns the pseudo st_dev corresponding to the union
>> > layer.
>> >
>> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>>
>> Chandan,
>>
>> Tests look correct, however, the tests are correct for a future
>> version of overlayfs
>> (overlayfs-devel branch) and we don't want to break unionmounts for current
>> stable kernel and not even for older kernels, so we have to maintain backward
>> compat somehow...
>> I suggest that you use the config flag self.config().is_verify(),
>> which I already
>> introduced in order to support old kernels w.r.t constant ino check,
>> as an indication for which st_dev can be expected in layer check.
>>
>> I think the rules should be:
>> 1. ./run --verify --samefs # should enforce all dentries on overlay st_dev
>> 2. ./run --verify # should enforce the rules that you wrote
>> 3. ./run [--samefs] # should allow for either old kernel rules or new rules
>>
>> Your challenge is to manage to describe all those rules in a clean and
>> short way,
>> just like you did with this patch.
>>
>> Good luck!
>> Amir.
>>
>> (see two more comments below)
>>
>> > ---
>> >  context.py | 10 ++++------
>> >  1 file changed, 4 insertions(+), 6 deletions(-)
>> >
>> > diff --git a/context.py b/context.py
>> > index 829fb69..f6dbbe7 100644
>> > --- a/context.py
>> > +++ b/context.py
>> > @@ -532,17 +532,15 @@ class test_context:
>> >          if self.skip_layer_test():
>> >              pass
>> >          elif dev == self.lower_fs():
>> > -            if dentry.is_dir():
>> > -                raise TestError(name + ": Directory unexpectedly on lower filesystem")
>> > +            # Overlayfs never returns st_dev corresponding to any of
>> > +            # the lower layers
>> > +            raise TestError(name + ": File unexpectedly has lowerfs dev id")
>> >          elif dentry.is_dir():
>> >              if dev != self.upper_dir_fs():
>> >                  raise TestError(name + ": Directory not on union layer")
>> >          elif dev == self.upper_fs() and not dentry.on_upper():
>> >              raise TestError(name + ": File unexpectedly on upper layer")
>>
>> You can and should also add the opposite check to enforce that:
>> if dentry.on_upper() and not self.config().is_samefs() and dev !=
>> self.upper_fs():
>>      "File unexpectedly not on upper layer"
>
> Hi Amir,
>
> The above check will fail on the newer kernels which might have non-dirs (on
> non-samefs overlay instances) which have been copied-up from a file originally
> present on lowerdir. For such files, on_upper will be set but st_dev would
> correspond to the pseudo device that ovl_getattr() returns.
>
>
> I have tried to groups together the tests within "is_samefs()" and
> "is_verify()" groups as shown below,
>
> diff --git a/context.py b/context.py
> index 829fb69..b6a980f 100644
> --- a/context.py
> +++ b/context.py
> @@ -530,20 +530,26 @@ class test_context:
>
>          #self.output("- check_layer ", dentry.filename(), " -", dentry.layer(), " # ", dev, "\n")
>          if self.skip_layer_test():
> -            pass
> -        elif dev == self.lower_fs():
> -            if dentry.is_dir():
> -                raise TestError(name + ": Directory unexpectedly on lower filesystem")
> -        elif dentry.is_dir():
> +            return
> +
> +        if self.config().is_samefs():
>              if dev != self.upper_dir_fs():
> +                raise TestError(name + ": File not on union layer")
> +
> +        if self.config().is_verify():
> +            if dev == self.lower_fs():
> +                # Overlayfs never returns st_dev corresponding to any of
> +                # the lower layers
> +                raise TestError(name + ": File unexpectedly on lower layer")
> +            if dentry.is_dir() and dev != self.upper_dir_fs():
>                  raise TestError(name + ": Directory not on union layer")
> -        elif dev == self.upper_fs() and not dentry.on_upper():
> +
> +        if dev == self.upper_fs() and not dentry.on_upper():
>              raise TestError(name + ": File unexpectedly on upper layer")
> -        elif dev != self.upper_fs() and dev != self.upper_dir_fs() and self.config().is_samefs():
> -            # For samefs, file is on overlay dev
> -            # TODO: for non-samefs, check file dev matches pseudo dev
> -            # and that pseduo dev != real dev
> -            raise TestError(name + ": File on unexpected layer")
> +
> +        if not self.config().is_samefs() and not self.config().is_verify() \
> +           and dentry.on_upper() and dev != self.upper_fs():
> +            raise TestError(name + ": File unexpectedly not on upper layer")
>
>          if dentry.is_sym() and dentry not in symlinks:
>              symlinks.add(dentry)
>
> However, as described above, the last added test fails on newer kernels. I
> am still trying to figure out an ideal place in check_layer() to add this
> test.
>
>

Chandan,

I think your tests will fail on upstream kernel and older kernels.

The test matrix to verify is at least:
 run --ov[=1] [--samefs] with kernel [v4.11|v4.12|overlayfs-next]
 run --ov[=1] --samefs --verify with kernel [4.12|overlayfs-next]
 run --ov[=1] --verify with kernel overlayfs-devel (with your patch)
* all overlayfs Kconfig options set to y

Maybe something like this.
It is not tested at all, so may be bogus. Please reply on specific
lines if you don't
follow the reasoning:

        if self.skip_layer_test():
            pass
        elif dentry.is_dir():
            # Directory inodes are always on overlay st_dev
            if dev != self.upper_dir_fs():
                raise TestError(name + ": Directory not on union layer")
            pass
        elif self.config().is_samefs():
            # With samefs setup, files are on overlay st_dev if st_ino
is constant
            # on copy up and on real st_dev if st_ino is not constant.
            # --verify verifies constant st_ino, so it implies overlay
st_dev check.
            # Without --verify, we allow for both options.
            if  dev == self.upper_dir_fs():
                pass
            if  self.config().is_verify():
                raise TestError(name + ": File not on union layer")
            if dev != self.upper_fs():
               raise TestError(name + ": File unexpectedly not on
lower/upper layer")
            pass
        else
            # With non samefs setup, files are on pseudo or upper
st_dev if st_ino
            # is constant on copy up and on lower or upper st_dev if
st_ino is not constant.
            # --verify verifies constant st_ino, so it implies pseudo
st_dev check.
            # Without --verify we allow for both options.
            # Lower file can be on upper fs when rotating upper layers (--ov=N).
            # TODO: stricter lower/upper checks for --ov=0.
            if  dev == self.upper_dir_fs():
                raise TestError(name + ": File unexpectedly on union layer")
            if dev == self.upper_fs():
                if not dentry.on_upper():
                    raise TestError(name + ": File unexpectedly on upper layer")
                pass
            if self.config().is_verify()
                if dev == self.lower_fs():
                    # Overlayfs returns pseudo st_dev or upper st_dev,
but never the lower layer
                    raise TestError(name + ": File unexpectedly on lower layer")
                pass
            if dev != self.upper_fs() and dev != self.lower_fs():
               raise TestError(name + ": File unexpectedly not on
lower/upper layer")
            pass

         if dentry.is_sym() and dentry not in symlinks:
             symlinks.add(dentry)
