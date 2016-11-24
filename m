From: Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [mm: ovl] cedf014d34: BUG: unable to handle kernel NULL pointer
 dereference at 0000000c
Date: Thu, 24 Nov 2016 17:02:42 +0100
Message-ID: <CAOssrKeObQoZnL6kSBunvYCQa=o4Foa-WB1kqxGFxJ2BuSN3YQ@mail.gmail.com>
References: <58370ae2.8FjkiU4UG6Q/BIVp%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:36544 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965473AbcKXQCp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Nov 2016 11:02:45 -0500
Received: by mail-lf0-f52.google.com with SMTP id t196so31970516lff.3
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Nov 2016 08:02:44 -0800 (PST)
In-Reply-To: <58370ae2.8FjkiU4UG6Q/BIVp%fengguang.wu@intel.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: kernel test robot <fengguang.wu@intel.com>
Cc: LKP <lkp@01.org>, wfg@linux.intel.com, linux-unionfs@vger.kernel.org

On Thu, Nov 24, 2016 at 4:44 PM, kernel test robot
<fengguang.wu@intel.com> wrote:
> Greetings,
>
> 0day kernel testing robot got the below dmesg and the first bad commit is
>
> https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-rorw
>
> commit cedf014d34d66438f99234f89d0db97889d9fc50

Great service, thanks!

Fixed and force pushed.

Miklos
