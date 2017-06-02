From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 2/5] ovl: relax same fs constrain for constant st_ino
Date: Fri, 2 Jun 2017 16:34:35 +0300
Message-ID: <CAOQ4uxhSVMspGL+JwZX2pSW-BJ_Am4z_eVv-6qAGq=EnpA_p=w@mail.gmail.com>
References: <1496307779-2766-1-git-send-email-amir73il@gmail.com>
 <1496307779-2766-3-git-send-email-amir73il@gmail.com> <CAJfpegtacnEncCkWQg4sE=ck6W2Utd6tJe3JsvAaeLoWEkRksw@mail.gmail.com>
 <CAOQ4uxjvBUEB89T0+qO4yksVeU+8KXEphOYxShMtQYiyNdxzLA@mail.gmail.com>
 <CAJfpeguGBDDgtgZjLu4xuQNehRUTvhMrxM1JG4dJcAt-1tPc=g@mail.gmail.com>
 <CAOQ4uxjD2WvxwB+dY=5oRoSJCdgqtYA0HQKu1afsiOdEnQKAMg@mail.gmail.com> <CAJfpegudj0ZQDixSGGmvtT6vmy-cQ+R5VdWhKbgw=mx5V9j-qQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:33898 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751229AbdFBNeh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 09:34:37 -0400
Received: by mail-oi0-f54.google.com with SMTP id o65so67433376oif.1
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Jun 2017 06:34:36 -0700 (PDT)
In-Reply-To: <CAJfpegudj0ZQDixSGGmvtT6vmy-cQ+R5VdWhKbgw=mx5V9j-qQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Jun 2, 2017 at 4:26 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Jun 2, 2017 at 3:23 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
>> I would like to start posting the index/hardlink patches, so though I would
>> flush out the constino buffer first.
>
> No need to resend, I'll just leave this out.
>

OK. Please do leave this patch in:
ovl: relax same fs constrain for ovl_check_origin()

index/hardlinks code does NOT assume samefs
and requires that lookup will find the origin also for non samefs case.

Thanks,
Amir.
