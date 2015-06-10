From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] overlayfs: Warn on copy up if a process has a R/O fd open to the lower file
Date: Wed, 10 Jun 2015 17:12:51 +0100
Message-ID: <17649.1433952771@warthog.procyon.org.uk>
References: <1433950405.375893.291973049.101362CB@webmail.messagingengine.com> <4954.1432838811@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433950405.375893.291973049.101362CB@webmail.messagingengine.com>
Content-ID: <17647.1433952771.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin Walters <walters@verbum.org>
Cc: dhowells@redhat.com, miklos@szeredi.hu, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Colin Walters <walters@verbum.org> wrote:

> On Thu, May 28, 2015, at 02:46 PM, David Howells wrote:
> > Print a warning when overlayfs copies up a file if the process that
> > triggered the copy up has a R/O fd open to the lower file being copied up.
> 
> Why not an option to make it an error?  If one's goal is to use overlayfs
> without apps potentially corrupting data, better to fail fast.

That could be added.  Note that doing this isn't *necessarily* wrong though.

David
