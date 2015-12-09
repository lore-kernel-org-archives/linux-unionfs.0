From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: check dentry positiveness in ovl_cleanup_whiteouts()
Date: Wed, 9 Dec 2015 22:51:34 +0100
Message-ID: <CAJfpeguUXTB5FVgbCMB+cRSbB4xkd06zPm-STc391yDXM7JQ5g@mail.gmail.com>
References: <20151116154411.6862.28435.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:36777 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbbLIVvf (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 9 Dec 2015 16:51:35 -0500
Received: by obcse5 with SMTP id se5so45970866obc.3
        for <linux-unionfs@vger.kernel.org>; Wed, 09 Dec 2015 13:51:34 -0800 (PST)
In-Reply-To: <20151116154411.6862.28435.stgit@buzz>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Kernel Mailing List <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Nov 16, 2015 at 4:44 PM, Konstantin Khlebnikov
<khlebnikov@yandex-team.ru> wrote:
> This patch fixes kernel crash at removing directory which contains
> whiteouts from lower layers.
>
> Cache of directory content passed as "list" contains entries from all
> layers, including whiteouts from lower layers. So, lookup in upper dir
> (moved into work at this stage) will return negative entry. Plus this
> cache is filled long before and we can race with external removal.
>
> Example:
>  mkdir -p lower0/dir lower1/dir upper work overlay
>  touch lower0/dir/a lower0/dir/b
>  mknod lower1/dir/a c 0 0
>  mount -t overlay none overlay -o lowerdir=lower1:lower0,upperdir=upper,workdir=work
>  rm -fr overlay/dir
>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Cc: Stable <stable@vger.kernel.org> # 3.18+

Thanks, applied.

Miklos
