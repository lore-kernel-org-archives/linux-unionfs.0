From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 2/2] vfs: add seq_file_path() helper
Date: Fri, 19 Jun 2015 09:31:05 +0100
Message-ID: <20150619083105.GL17109@ZenIV.linux.org.uk>
References: <20150619082913.GB24181@tucsk>
 <20150619083028.GC24181@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150619083028.GC24181@tucsk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jun 19, 2015 at 10:30:28AM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Turn
> 	seq_path(..., &file->f_path, ...);
> into
> 	seq_file_path(..., file, ...);

Both applied.
