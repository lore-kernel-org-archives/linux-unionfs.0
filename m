From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 15/23] ovl: index directories on copy up with 'verify=on'
Date: Tue, 9 Jan 2018 17:08:39 +0100
Message-ID: <CAJfpegsXCm-EG=Odpy0sBiK-htJEH4nRqSNn0Qd0o0YtQ=gBZg@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com> <1515084018-25134-16-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:40809 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933171AbeAIQIk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jan 2018 11:08:40 -0500
Received: by mail-qk0-f180.google.com with SMTP id d18so8750141qke.7
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jan 2018 08:08:40 -0800 (PST)
In-Reply-To: <1515084018-25134-16-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Jan 4, 2018 at 5:40 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> With the 'verify' feature enabled, all dirs are indexed on copy up.
> Non-dir files are copied up directly to indexdir and then hardlinked
> to upper dir.
>
> Directories are copied up to indexdir, then an index entry is created

Makes me wonder:  do we need a workdir at all?  Temp files are already
differentiated by leading "#", so that takes care of cleanup.
Advantage: one less directory to worry about in implementation.

Thanks,
Miklos
