From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] overlayfs: Pass O_LARGEFILE unconditionally in ovl_copy_up_data()
Date: Mon, 12 Oct 2015 17:26:38 +0200
Message-ID: <CAJfpeguFWY=WXQcnurCjTkd_WFxuFCfT1AuDWYjC5zF6UeF5dw@mail.gmail.com>
References: <20150928141806.21007.8412.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35755 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbbJLP0i (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 12 Oct 2015 11:26:38 -0400
Received: by oiao187 with SMTP id o187so28098366oia.2
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Oct 2015 08:26:38 -0700 (PDT)
In-Reply-To: <20150928141806.21007.8412.stgit@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>

On Mon, Sep 28, 2015 at 4:18 PM, David Howells <dhowells@redhat.com> wrote:
> Pass O_LARGEFILE unconditionally in ovl_copy_up_data() as it's purely for
> catching 32-bit userspace dealing with a file large enough that it'll be
> mishandled if the application isn't aware that there might be an integer
> overflow.  Inside the kernel, there shouldn't be any problems.

Folded into original patch with changelog added.

Thanks,
Miklos
