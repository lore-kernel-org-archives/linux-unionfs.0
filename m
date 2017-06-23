From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH V2] ovl: Allocate anonymous devs for lowerdirs
Date: Fri, 23 Jun 2017 16:34:57 +0300
Message-ID: <CAOQ4uxjf-MUQTisMHL96Ao3P+NXRG5QnJmmd0iptcgyYGB72=Q@mail.gmail.com>
References: <20170623110118.19975-1-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33729 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753701AbdFWNe7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 23 Jun 2017 09:34:59 -0400
Received: by mail-oi0-f65.google.com with SMTP id j63so3955243oiy.0
        for <linux-unionfs@vger.kernel.org>; Fri, 23 Jun 2017 06:34:58 -0700 (PDT)
In-Reply-To: <20170623110118.19975-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Jun 23, 2017 at 2:01 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> For stat(2) on lowerdir non-dir entries in non-samefs case, this commit
> provides unique values for st_dev. The unique values are obtained by
> allocating anonymous bdevs for each of the lowerdirs in the overlayfs
> instance.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Amir Goldstein <amir73il@gmail.com>

Miklos,

I re-created the branch ovl-constino [1] on top of ovl-hardlinks and without
the consistent dino patches.

Applied Chandan's patch and resolved conflicts with my patches.
Then, applied my patch to relax constant st_ino  for non-samefs on stat(2).

Mutilated unionmount-testsuite layers check [2] to get over the unexpected
pseudo dev and now tests pass for non samefs including constant ino
verification and persistent ino verification for non-dir.

Chandan,

If you can fix the mutilated unionmount-testsuite check_layer(), that would be
nice.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-constino
[2] https://github.com/amir73il/unionmount-testsuite/commits/ovl-constino
