From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] ovl: properly implement sync_filesystem()
Date: Tue, 24 Jan 2017 09:14:54 -0800
Message-ID: <20170124171454.GA31414@infradead.org>
References: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
 <1484828008-27507-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484828008-27507-3-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

s/sync_filesystem()/->sync_fs/ in the subject?

Otherwise this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
