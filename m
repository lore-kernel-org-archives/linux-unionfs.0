From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/4] src/open_by_handle: helper to test open_by_handle_at() syscall
Date: Wed, 19 Apr 2017 10:51:22 +0100
Message-ID: <9896.1492595482@warthog.procyon.org.uk>
References: <1492539444-25938-2-git-send-email-amir73il@gmail.com> <1492539444-25938-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41816 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759968AbdDSJvZ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 05:51:25 -0400
In-Reply-To: <1492539444-25938-2-git-send-email-amir73il@gmail.com>
Content-ID: <9895.1492595482.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: dhowells@redhat.com, Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

Amir Goldstein <amir73il@gmail.com> wrote:

> This is a clone of src/stale_handle.c test that uses generic
> open_by_handle_at() syscall instead of the xfs specific ioctl.

Don't forget to add it to doc/auxiliary-programs.txt!

David
