From: David Howells <dhowells@redhat.com>
Subject: Re: Locking problem in overlayfs
Date: Mon, 27 Oct 2014 15:44:50 +0000
Message-ID: <12801.1414424690@warthog.procyon.org.uk>
References: <20141027144201.GD3021@tucsk.piliscsaba.szeredi.hu> <20141027141935.GC3021@tucsk.piliscsaba.szeredi.hu> <5394.1414418718@warthog.procyon.org.uk> <6032.1414420761@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141027144201.GD3021@tucsk.piliscsaba.szeredi.hu>
Content-ID: <12800.1414424690.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Yes, following (untested) patch should fix it:

Tested-by: David Howells <dhowells@redhat.com>
