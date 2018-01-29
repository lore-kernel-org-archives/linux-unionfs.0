From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 2/5] overlay: test encode/decode overlay file handles
Date: Mon, 29 Jan 2018 19:23:49 +0200
Message-ID: <CAOQ4uxiRg9ZddvnzW-X8VMqpGOWva42qZmmBzdXUqoy-n34NRg@mail.gmail.com>
References: <1517131356-8048-1-git-send-email-amir73il@gmail.com>
 <1517131356-8048-3-git-send-email-amir73il@gmail.com> <20180129143940.GW18267@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f179.google.com ([209.85.213.179]:39786 "EHLO
        mail-yb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751338AbeA2RXv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 29 Jan 2018 12:23:51 -0500
In-Reply-To: <20180129143940.GW18267@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Mon, Jan 29, 2018 at 4:39 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Sun, Jan 28, 2018 at 11:22:33AM +0200, Amir Goldstein wrote:
>> - Check encode/write/decode/read content of lower/upper file handles
>> - Check encode/decode/write/read content of lower/upper file handles
>> - Check decode/read of unlinked lower/upper files and directories
>> - Check decode/read of lower file handles after copy up, link and unlink
>>
>> This test requires and enables overlayfs NFS export support.
>> NFS export support depends on and enables overlayfs index feature.
>>
>> This test covers only encode/decode of file handles for overlayfs
>> configuration of all layers on the same base fs.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> Looks good to me overall, just two minor issues in comments.
>

OK. I fixed those comment in both test variants.
Let me know if there is anything else, otherwise, I'll re-post
with fixed to comment on patch 1.

Thanks,
Amir.
