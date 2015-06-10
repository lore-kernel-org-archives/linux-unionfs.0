From: Colin Walters <walters@verbum.org>
Subject: Re: [PATCH] overlayfs: Warn on copy up if a process has a R/O fd open to
 the lower file
Date: Wed, 10 Jun 2015 11:33:25 -0400
Message-ID: <1433950405.375893.291973049.101362CB@webmail.messagingengine.com>
References: <4954.1432838811@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52044 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965060AbbFJPd0 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 10 Jun 2015 11:33:26 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id 7D10A20F01
	for <linux-unionfs@vger.kernel.org>; Wed, 10 Jun 2015 11:33:25 -0400 (EDT)
In-Reply-To: <4954.1432838811@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>, miklos@szeredi.hu, viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

On Thu, May 28, 2015, at 02:46 PM, David Howells wrote:
> Print a warning when overlayfs copies up a file if the process that triggered
> the copy up has a R/O fd open to the lower file being copied up.

Why not an option to make it an error?  If one's goal is to use overlayfs
without apps potentially corrupting data, better to fail fast.
