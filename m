From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 23/23] ovl: copy up of disconnected dentries
Date: Thu, 11 Jan 2018 17:28:31 +0200
Message-ID: <CAOQ4uxj-o-LUduzRXZFz1oNkLx8iKthEbhM_ZQhPFCtU=X9Y9w@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-24-git-send-email-amir73il@gmail.com> <CAJfpegs4Ehusis0YROPJtiNzhbmx6+U29vGbhYC=pXjzQ8tZcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f177.google.com ([209.85.213.177]:46795 "EHLO
        mail-yb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932197AbeAKP2d (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 11 Jan 2018 10:28:33 -0500
Received: by mail-yb0-f177.google.com with SMTP id b39so1220498ybj.13
        for <linux-unionfs@vger.kernel.org>; Thu, 11 Jan 2018 07:28:33 -0800 (PST)
In-Reply-To: <CAJfpegs4Ehusis0YROPJtiNzhbmx6+U29vGbhYC=pXjzQ8tZcA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Jan 11, 2018 at 4:47 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Jan 4, 2018 at 5:40 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> With NFS export, some operations on decoded file handles (e.g. open,
>> link, setattr, xattr_set) may call copy up with a disconnected non-dir.
>> In this case, we will copy up lower inode to index dir without
>> linking it to upper dir.
>
> Did we not have plans to link-up from index on lookup, when upper link
> is missing?  For consistency sake, that would make a lot of sense
> after such a disconnected copy-up, and also for the hardlink copy-up.
>
> Yes, things work without the upper link, but restoring the upper link
> makes sense, and lookup is perhaps the most logical place to do that
> restoration.
>

Indeed, disconnected copy-up is a lot like hardlink copy-up+unlink.
I guess the link-up on lookup is independent of the series, but should
be doable.

Thanks,
Amir.
