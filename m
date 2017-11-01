From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v5 2/4] ovl: allocate anonymous devs for lowerdirs
Date: Wed, 1 Nov 2017 18:30:39 +0200
Message-ID: <CAOQ4uxiE33OrPYwY4WwgT7mZ8i9PDKTZMcTMFhfNtXvRE6RYsg@mail.gmail.com>
References: <1509395247-15180-1-git-send-email-amir73il@gmail.com>
 <1509395247-15180-3-git-send-email-amir73il@gmail.com> <20171101154145.GA4738@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:49392 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752340AbdKAQak (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Nov 2017 12:30:40 -0400
Received: by mail-yw0-f196.google.com with SMTP id z195so2312022ywz.6
        for <linux-unionfs@vger.kernel.org>; Wed, 01 Nov 2017 09:30:40 -0700 (PDT)
In-Reply-To: <20171101154145.GA4738@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Chandan Rajendra <chandan@linux.vnet.ibm.com>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Nov 1, 2017 at 5:41 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Oct 30, 2017 at 10:27:25PM +0200, Amir Goldstein wrote:
>> From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>>
>> For stat(2) on lowerdir non-dir entries in non-samefs case, this commit
>> provides unique values for st_dev. The unique values are obtained by
>> allocating anonymous bdevs for each of the lowerdirs in the overlayfs
>> instance.
>>
>> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>> [amir: rename to struct ovl_layer lower_layers and struct ovl_path]
>
> Hi Amir,
>
> Would it make sense to do all the renaming in a separate patch. It becomes
> much easier to review this patch then. May be renaming can go first and
> then anonymous bdev patch can come in.
>

Sounds good. I'll do it.
