From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2] ovl: drop CAP_SYS_RESOURCE from saved mounter's credentials
Date: Mon, 24 Jul 2017 10:19:07 +0200
Message-ID: <CAJfpegsaRiyamrqqU8MRm+c-scO9Kco+nqxbv=zX3SNEoHeqZA@mail.gmail.com>
References: <148404760886.4400.14907571208759802396.stgit@buzz>
 <148407302133.16047.411379729888561193.stgit@buzz> <20170110191721.GF23108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34172 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751684AbdGXITI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Jul 2017 04:19:08 -0400
Received: by mail-oi0-f66.google.com with SMTP id v11so7882860oif.1
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Jul 2017 01:19:08 -0700 (PDT)
In-Reply-To: <20170110191721.GF23108@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>

On Tue, Jan 10, 2017 at 8:17 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Jan 10, 2017 at 09:30:21PM +0300, Konstantin Khlebnikov wrote:
>> If overlay was mounted by root then quota set for upper layer does not work
>> because overlay now always use mounter's credentials for operations.
>> Also overlay might deplete reserved space and inodes in ext4.
>>
>> This patch drops capability SYS_RESOURCE from saved credentials.
>> This affects creation new files, whiteouts, and copy-up operations.
>>
>
> I am not an expert in this area, but I thought previous patch was
> better. I am not sure why overlay internal operations should be
> done without CAP_SYS_RESOURCES when caller has CAP_SYS_RESOURCES. That
> might be counter-intuitive.
>
> If some task is allowed to bypass quota limitations on a file system
> then same should be true when task is working on overlay.
>
> Similary if a task is allowed to use reserved space on filesystem, then same
> task should be allowed to use reserved space on underlying filesystem
> when doing overlay.  It should not be overlay's job to prevent that?
>
> May be it is just me....

Well, depends how you look at at it.  Overlayfs just uses the
underlying filesystem as storage.  So this patch basically asserts
that overlayfs can only use non-reserved space for its storage.  I
don't see a problem with and it's the simpler fix, but if real use
cases turn up then this can be revisited.

Thanks,
Miklos
