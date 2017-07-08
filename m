From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] check_layer: Add tests for constant st_dev
Date: Sat, 8 Jul 2017 11:12:41 +0300
Message-ID: <CAOQ4uxicgyZRKxBVv+KTU8jQ0g7kSS7TWcjpNj8v5Za_gsP9iA@mail.gmail.com>
References: <20170704170028.4278-1-chandan@linux.vnet.ibm.com>
 <CAOQ4uxiS9b7GboLpV2-FekiD+uND3Nofiybdr_=w-XcvhH+pkw@mail.gmail.com>
 <3081705.s7MyyWUpSq@localhost.localdomain> <CAOQ4uxhf4-kG8s7WLE_3tsPObiZnCdm+4C07hoFgs=swWTZs4A@mail.gmail.com>
 <CAOQ4uxjuKCGGK1shB1YO3Ony5Gqcv_mm7kidoeO8mgvnTqi7kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:33322 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbdGHIMn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 8 Jul 2017 04:12:43 -0400
Received: by mail-yb0-f194.google.com with SMTP id 84so2264828ybe.0
        for <linux-unionfs@vger.kernel.org>; Sat, 08 Jul 2017 01:12:43 -0700 (PDT)
In-Reply-To: <CAOQ4uxjuKCGGK1shB1YO3Ony5Gqcv_mm7kidoeO8mgvnTqi7kw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Sat, Jul 8, 2017 at 12:09 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Jul 7, 2017 at 11:35 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
>> Chandan,
>>
>> I think your tests will fail on upstream kernel and older kernels.
>>
>> The test matrix to verify is at least:
>>  run --ov[=1] [--samefs] with kernel [v4.11|v4.12|overlayfs-next]
>>  run --ov[=1] --samefs --verify with kernel [4.12|overlayfs-next]
>>  run --ov[=1] --verify with kernel overlayfs-devel (with your patch)
>> * all overlayfs Kconfig options set to y
>>
>> Maybe something like this.
>> It is not tested at all, so may be bogus. Please reply on specific
>> lines if you don't
>> follow the reasoning:
>>
>
> Sorry for all the messed up spaced and line wrapping...
>
>>         if self.skip_layer_test():
>>             pass
>>         elif dentry.is_dir():
>>             # Directory inodes are always on overlay st_dev
>>             if dev != self.upper_dir_fs():
>>                 raise TestError(name + ": Directory not on union layer")
>>             pass
>>         elif self.config().is_samefs():
>>             # With samefs setup, files are on overlay st_dev if st_ino
>> is constant
>>             # on copy up and on real st_dev if st_ino is not constant.
>>             # --verify verifies constant st_ino, so it implies overlay
>> st_dev check.
>>             # Without --verify, we allow for both options.
>>             if  dev == self.upper_dir_fs():
>>                 pass
>>             if  self.config().is_verify():
>>                 raise TestError(name + ": File not on union layer")
>>             if dev != self.upper_fs():
>>                raise TestError(name + ": File unexpectedly not on
>> lower/upper layer")
>>             pass
>>         else
>>             # With non samefs setup, files are on pseudo or upper
>> st_dev if st_ino
>>             # is constant on copy up and on lower or upper st_dev if
>> st_ino is not constant.
>>             # --verify verifies constant st_ino, so it implies pseudo
>> st_dev check.
>>             # Without --verify we allow for both options.
>
>>             # Lower file can be on upper fs when rotating upper layers (--ov=N).
>>             # TODO: stricter lower/upper checks for --ov=0.
>
> Don't think this comment about Lower file is relevant to these test cases.
> I think in this context, not dentry.on_upper() means on lowermost layer,
> which is either self.lower_fs() or pseudo dev.
>
>>             if  dev == self.upper_dir_fs():
>>                 raise TestError(name + ": File unexpectedly on union layer")
>>             if dev == self.upper_fs():
>>                 if not dentry.on_upper():
>>                     raise TestError(name + ": File unexpectedly on upper layer")
>>                 pass
>>             if self.config().is_verify()
>>                 if dev == self.lower_fs():
>>                     # Overlayfs returns pseudo st_dev or upper st_dev,
>> but never the lower layer
>>                     raise TestError(name + ": File unexpectedly on lower layer")
>>                 pass
>>             if dev != self.upper_fs() and dev != self.lower_fs():
>>                raise TestError(name + ": File unexpectedly not on
>> lower/upper layer")
>
> Yeah, this last test is wrong because without --verify, pseudo st_dev
> is still allowed.
> Instead could check:
>              if dev == self.lower_fs() and dentry.on_upper():
>                 raise TestError(name + ": File unexpectedly on lower layer")
>
>
>>             pass
>>
>>          if dentry.is_sym() and dentry not in symlinks:
>>              symlinks.add(dentry)

OK, my pseudo patch was mostly correct, but full of brainoes,
push a tested patch to
https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel

Please review and verify.

Thanks,
Amir.
