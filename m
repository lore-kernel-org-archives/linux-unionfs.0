From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] overlayfs: Warn on copy up if a process has a R/O fd open to the lower file
Date: Mon, 22 Jun 2015 16:10:33 +0100
Message-ID: <28487.1434985833@warthog.procyon.org.uk>
References: <4954.1432838811@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4954.1432838811@warthog.procyon.org.uk>
Content-ID: <28486.1434985833.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, miklos@szeredi.hu, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Al,

> Print a warning when overlayfs copies up a file if the process that triggered
> the copy up has a R/O fd open to the lower file being copied up.

Can you take this?

David
