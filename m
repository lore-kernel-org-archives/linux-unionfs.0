From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH V2 0/2] ovl: implement async IO routines
Date: Fri, 24 Jan 2020 13:10:48 +0100
Message-ID: <CAJfpegsOt0cX-8dN-3Fq=bfqmxYCDu=7eN_-=5rusy5VTjD3Mg@mail.gmail.com>
References: <1574243126-59283-1-git-send-email-jiufei.xue@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io1-f67.google.com ([209.85.166.67]:34689 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730050AbgAXMK7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 24 Jan 2020 07:10:59 -0500
Received: by mail-io1-f67.google.com with SMTP id z193so1643801iof.1
        for <linux-unionfs@vger.kernel.org>; Fri, 24 Jan 2020 04:10:59 -0800 (PST)
In-Reply-To: <1574243126-59283-1-git-send-email-jiufei.xue@linux.alibaba.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc: Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Wed, Nov 20, 2019 at 10:45 AM Jiufei Xue
<jiufei.xue@linux.alibaba.com> wrote:
>
> ovl stacks regular file operations now. However it doesn't implement
> async IO routines and will convert async IOs to sync IOs which is not
> expected.
>
> This patchset implements overlayfs async IO routines.

Thanks,  pushed to overlayfs-next with slight modifications.

Miklos
