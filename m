From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: Pass ovl_get_nlink() parameters in right order
Date: Thu, 7 Dec 2017 11:57:51 +0100
Message-ID: <CAJfpegsKrY=ebebQPKNd8TqmoWBCSZ=Xm5+aPR8DvR3mc=csMQ@mail.gmail.com>
References: <20171127151244.GA22007@redhat.com> <CAOQ4uxjSFNE7_-a=Ah4wgRjoQwyRn0PrukchmNUNyKEGDysiHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:42843 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752457AbdLGK5w (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Dec 2017 05:57:52 -0500
Received: by mail-qt0-f182.google.com with SMTP id g9so16363783qth.9
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Dec 2017 02:57:52 -0800 (PST)
In-Reply-To: <CAOQ4uxjSFNE7_-a=Ah4wgRjoQwyRn0PrukchmNUNyKEGDysiHQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Nov 27, 2017 at 7:24 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Nov 27, 2017 at 5:12 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> Hi Amir,
>>
>> I am wondering if this is a bug or it is supposed to be like this. I felt
>> it is a bug, so I generated a patch and sending it for your review.
>>
>
> Yap. That's a bug. Good catch!
> I fixed test overlay/033 to catch it.
>
> Please add cc:stable # v4.13 and Fixes tag.

Thanks Vivek. Added the stable and fixes tags and taken the above as
an Acked-by from Amir.

Thanks,
Miklos
