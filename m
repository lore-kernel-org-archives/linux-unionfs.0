From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] check_layer: Add tests for constant st_dev
Date: Tue, 4 Jul 2017 21:03:57 +0300
Message-ID: <CAOQ4uxiS9b7GboLpV2-FekiD+uND3Nofiybdr_=w-XcvhH+pkw@mail.gmail.com>
References: <20170704170028.4278-1-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33527 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752031AbdGDSD6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 4 Jul 2017 14:03:58 -0400
Received: by mail-oi0-f67.google.com with SMTP id f134so17009273oig.0
        for <linux-unionfs@vger.kernel.org>; Tue, 04 Jul 2017 11:03:58 -0700 (PDT)
In-Reply-To: <20170704170028.4278-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Jul 4, 2017 at 8:00 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> With constant st_dev implemented, overlayfs never returns the real dev
> corresponding to lowerdir filesystems. Also, for the samefs case,
> overlayfs always returns the pseudo st_dev corresponding to the union
> layer.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Chandan,

Tests look correct, however, the tests are correct for a future
version of overlayfs
(overlayfs-devel branch) and we don't want to break unionmounts for current
stable kernel and not even for older kernels, so we have to maintain backward
compat somehow...
I suggest that you use the config flag self.config().is_verify(),
which I already
introduced in order to support old kernels w.r.t constant ino check,
as an indication for which st_dev can be expected in layer check.

I think the rules should be:
1. ./run --verify --samefs # should enforce all dentries on overlay st_dev
2. ./run --verify # should enforce the rules that you wrote
3. ./run [--samefs] # should allow for either old kernel rules or new rules

Your challenge is to manage to describe all those rules in a clean and
short way,
just like you did with this patch.

Good luck!
Amir.

(see two more comments below)

> ---
>  context.py | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/context.py b/context.py
> index 829fb69..f6dbbe7 100644
> --- a/context.py
> +++ b/context.py
> @@ -532,17 +532,15 @@ class test_context:
>          if self.skip_layer_test():
>              pass
>          elif dev == self.lower_fs():
> -            if dentry.is_dir():
> -                raise TestError(name + ": Directory unexpectedly on lower filesystem")
> +            # Overlayfs never returns st_dev corresponding to any of
> +            # the lower layers
> +            raise TestError(name + ": File unexpectedly has lowerfs dev id")
>          elif dentry.is_dir():
>              if dev != self.upper_dir_fs():
>                  raise TestError(name + ": Directory not on union layer")
>          elif dev == self.upper_fs() and not dentry.on_upper():
>              raise TestError(name + ": File unexpectedly on upper layer")

You can and should also add the opposite check to enforce that:
if dentry.on_upper() and not self.config().is_samefs() and dev !=
self.upper_fs():
     "File unexpectedly not on upper layer"

> -        elif dev != self.upper_fs() and dev != self.upper_dir_fs() and self.config().is_samefs():
> -            # For samefs, file is on overlay dev
> -            # TODO: for non-samefs, check file dev matches pseudo dev
> -            # and that pseduo dev != real dev
> +        elif dev != self.upper_dir_fs() and self.config().is_samefs():
>              raise TestError(name + ": File on unexpected layer")

Here, the error could be more descriptive "File not on union layer"
