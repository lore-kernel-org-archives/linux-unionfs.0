From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] ovl: fix reStructuredText syntax errors in
 documentation
Date: Thu, 15 Dec 2016 07:25:53 -0700
Message-ID: <20161215072553.1beb3ad0@lwn.net>
References: <1481183391-30405-1-git-send-email-amir73il@gmail.com>
        <CAOQ4uxg8s_1ATqFFD6__2dez9-VYqR2NpFQ5iU8zvCDYLib0Pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:38302 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752693AbcLOOcW (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 15 Dec 2016 09:32:22 -0500
In-Reply-To: <CAOQ4uxg8s_1ATqFFD6__2dez9-VYqR2NpFQ5iU8zvCDYLib0Pw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: NeilBrown <neilb@suse.com>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>

On Thu, 15 Dec 2016 09:58:31 +0200
Amir Goldstein <amir73il@gmail.com> wrote:

> Ping.

Patches that show up right before the merge window opens can get the
back-burner treatment for a bit, sorry.

> Neil,
> I found these syntax errors when I posted your page on my wiki:
> https://github.com/amir73il/overlayfs/wiki/Overlayfs-overview
> 
The "errors" are unsurprising, given that this is not (yet) an RST file.

What we would *really* like to do is integrate this into the growing body
of Sphinx documentation.  That involves thinking about where filesystem
documentation goes in that world, either in the admin manual or into a
new one.

Meanwhile, though, the RST conversion on this file is a fine thing to do,
and I'll be happy to apply the patch once I start working on 4.11 stuff.

Thanks,

jon
