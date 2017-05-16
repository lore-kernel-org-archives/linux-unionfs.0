From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs in 4.12-rc1. Files in lower become unwritable in the overlay
Date: Tue, 16 May 2017 09:02:18 +0200
Message-ID: <CAJfpegtf4QXFPJ60ra767iA1o_NPmjO10WaaVSG_-5RZgCfT+w@mail.gmail.com>
References: <E1dAI7k-0006Fd-6q@tux00.mathematik.uni-freiburg.de>
 <CAJfpegs_FGhA4yj=W6eraLrw4GAavTv1-Zxwj27XM4QgGvo-_Q@mail.gmail.com> <CAOQ4uxiyx5n60vuSU+zxCsGVF6Si3rNWaGLyYzv=Ky5md2RDUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:33485 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751156AbdEPHCU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 May 2017 03:02:20 -0400
Received: by mail-oi0-f44.google.com with SMTP id w10so14351294oif.0
        for <linux-unionfs@vger.kernel.org>; Tue, 16 May 2017 00:02:20 -0700 (PDT)
In-Reply-To: <CAOQ4uxiyx5n60vuSU+zxCsGVF6Si3rNWaGLyYzv=Ky5md2RDUQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Martin Ziegler <ziegler@uni-freiburg.de>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, May 15, 2017 at 11:52 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, May 15, 2017 at 8:57 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:

>> Thanks for the report.  Fix pushed to overlayfs-next branch of
>> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git
>>
>
> I don't see the fix on the branch..

Sorry, forgot to push.  Done now.

Thanks,
Miklos
