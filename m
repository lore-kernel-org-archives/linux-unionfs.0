From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs in 4.12-rc1. Files in lower become unwritable in the overlay
Date: Tue, 16 May 2017 09:42:36 +0200
Message-ID: <CAJfpeguTGqFVp+CwcKxq5SY19US8gvqU1BZcHO04y=zbo5pxdQ@mail.gmail.com>
References: <E1dAI7k-0006Fd-6q@tux00.mathematik.uni-freiburg.de>
 <CAJfpegs_FGhA4yj=W6eraLrw4GAavTv1-Zxwj27XM4QgGvo-_Q@mail.gmail.com>
 <CAOQ4uxiyx5n60vuSU+zxCsGVF6Si3rNWaGLyYzv=Ky5md2RDUQ@mail.gmail.com>
 <CAJfpegtf4QXFPJ60ra767iA1o_NPmjO10WaaVSG_-5RZgCfT+w@mail.gmail.com> <CAOQ4uxix2eCuCCVJViYhhvEqaLBCAHnV14XK2nzBUoUd7dOSWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35889 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751591AbdEPHmi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 May 2017 03:42:38 -0400
Received: by mail-oi0-f43.google.com with SMTP id h4so15166438oib.3
        for <linux-unionfs@vger.kernel.org>; Tue, 16 May 2017 00:42:37 -0700 (PDT)
In-Reply-To: <CAOQ4uxix2eCuCCVJViYhhvEqaLBCAHnV14XK2nzBUoUd7dOSWg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Martin Ziegler <ziegler@uni-freiburg.de>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, May 16, 2017 at 9:27 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, May 16, 2017 at 10:02 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Mon, May 15, 2017 at 11:52 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On Mon, May 15, 2017 at 8:57 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>>>> Thanks for the report.  Fix pushed to overlayfs-next branch of
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git
>>>>
>>>
>>> I don't see the fix on the branch..
>>
>> Sorry, forgot to push.  Done now.
>>
>
> Fix looks ok, but I wonder: upper fs with no xattr support is really a crippled
> case we only need to support for backward compat. right?

Yes, xattr is needed for opaque dir too, where we error out because
there's no sane fallback.  In fact there's a bit of a back-incompat
thing due to 97c684cc9110 ("ovl: create directories inside merged
parent opaque") trying to add the opaque flag even when not strictly
needed and failing if xattr isn't supported, whereas before the patch
that case wouldn't fail.

>
> How about pre testing the noxattr condition on mount time (on workdir)
> and issue a warning at mount time along the same lines of:
>    pr_warn("overlayfs: upper fs needs to support d_type.\n");
>    pr_warn("overlayfs: upper fs does not support tmpfile.\n");
>    pr_warn("overlayfs: upper fs does not support xattr.\n");

We could.   Theoretically we'd need to test for each xattr separately,
but it's highly unlikely that a filesystem would support only a subset
of the trusted.overlay.* namespace.

Thanks,
Miklos
