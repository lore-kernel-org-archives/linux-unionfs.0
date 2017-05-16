From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: overlayfs in 4.12-rc1. Files in lower become unwritable in the overlay
Date: Tue, 16 May 2017 10:27:38 +0300
Message-ID: <CAOQ4uxix2eCuCCVJViYhhvEqaLBCAHnV14XK2nzBUoUd7dOSWg@mail.gmail.com>
References: <E1dAI7k-0006Fd-6q@tux00.mathematik.uni-freiburg.de>
 <CAJfpegs_FGhA4yj=W6eraLrw4GAavTv1-Zxwj27XM4QgGvo-_Q@mail.gmail.com>
 <CAOQ4uxiyx5n60vuSU+zxCsGVF6Si3rNWaGLyYzv=Ky5md2RDUQ@mail.gmail.com> <CAJfpegtf4QXFPJ60ra767iA1o_NPmjO10WaaVSG_-5RZgCfT+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33247 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751264AbdEPH1j (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 May 2017 03:27:39 -0400
Received: by mail-oi0-f48.google.com with SMTP id w10so14961163oif.0
        for <linux-unionfs@vger.kernel.org>; Tue, 16 May 2017 00:27:39 -0700 (PDT)
In-Reply-To: <CAJfpegtf4QXFPJ60ra767iA1o_NPmjO10WaaVSG_-5RZgCfT+w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Martin Ziegler <ziegler@uni-freiburg.de>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, May 16, 2017 at 10:02 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, May 15, 2017 at 11:52 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Mon, May 15, 2017 at 8:57 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>>> Thanks for the report.  Fix pushed to overlayfs-next branch of
>>> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git
>>>
>>
>> I don't see the fix on the branch..
>
> Sorry, forgot to push.  Done now.
>

Fix looks ok, but I wonder: upper fs with no xattr support is really a crippled
case we only need to support for backward compat. right?

How about pre testing the noxattr condition on mount time (on workdir)
and issue a warning at mount time along the same lines of:
   pr_warn("overlayfs: upper fs needs to support d_type.\n");
   pr_warn("overlayfs: upper fs does not support tmpfile.\n");
   pr_warn("overlayfs: upper fs does not support xattr.\n");
