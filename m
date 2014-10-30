From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] Overlayfs: ovl_fill_merge() should use container_of()
 rather than direct cast
Date: Thu, 30 Oct 2014 15:36:02 +0100
Message-ID: <CAJfpegv5dqfgze-9pxDD-O19tctS-4P12NsO2oCo5SF1bqhhHA@mail.gmail.com>
References: <20141030141004.28203.79687.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:48392 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759963AbaJ3OgE (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 30 Oct 2014 10:36:04 -0400
Received: by mail-qg0-f42.google.com with SMTP id i50so3121515qgf.15
        for <linux-unionfs@vger.kernel.org>; Thu, 30 Oct 2014 07:36:02 -0700 (PDT)
In-Reply-To: <20141030141004.28203.79687.stgit@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, Kernel Mailing List <linux-kernel@vger.kernel.org>

On Thu, Oct 30, 2014 at 3:10 PM, David Howells <dhowells@redhat.com> wrote:
> ovl_fill_merge() effectively directly casts the buf pointer to an
> ovl_readdir_data struct pointer, but the pointer actually points to the
> dir_context struct contained therein.
>
> So use container_of() instead.
>
> Signed-off-by: David Howells <dhowells@redhat.com>

Okay, but why don't we have a typed argument of actor then?

Being typeless is encouraging exactly the kind of games overlayfs is
doing (probably copied mindlessly from some other part of the kernel).

Thanks,
Miklos
