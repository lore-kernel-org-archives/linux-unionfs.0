From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 23/23] ovl: copy up of disconnected dentries
Date: Thu, 11 Jan 2018 15:47:03 +0100
Message-ID: <CAJfpegs4Ehusis0YROPJtiNzhbmx6+U29vGbhYC=pXjzQ8tZcA@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com> <1515084018-25134-24-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:41596 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932318AbeAKOrE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 11 Jan 2018 09:47:04 -0500
Received: by mail-qk0-f173.google.com with SMTP id a8so4531398qkb.8
        for <linux-unionfs@vger.kernel.org>; Thu, 11 Jan 2018 06:47:04 -0800 (PST)
In-Reply-To: <1515084018-25134-24-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Jan 4, 2018 at 5:40 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> With NFS export, some operations on decoded file handles (e.g. open,
> link, setattr, xattr_set) may call copy up with a disconnected non-dir.
> In this case, we will copy up lower inode to index dir without
> linking it to upper dir.

Did we not have plans to link-up from index on lookup, when upper link
is missing?  For consistency sake, that would make a lot of sense
after such a disconnected copy-up, and also for the hardlink copy-up.

Yes, things work without the upper link, but restoring the upper link
makes sense, and lookup is perhaps the most logical place to do that
restoration.

Thanks,
Miklos
