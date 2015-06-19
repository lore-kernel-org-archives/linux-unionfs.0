From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/2] vfs: add file_path() helper
Date: Fri, 19 Jun 2015 09:30:40 +0100
Message-ID: <20150619083040.GK17109@ZenIV.linux.org.uk>
References: <20150619082913.GB24181@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:53500 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbbFSIan (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 19 Jun 2015 04:30:43 -0400
Content-Disposition: inline
In-Reply-To: <20150619082913.GB24181@tucsk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, Jun 19, 2015 at 10:29:13AM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Turn
> 	d_path(&file->f_path, ...);
> into
> 	file_path(file, ...);

Makes sense.
