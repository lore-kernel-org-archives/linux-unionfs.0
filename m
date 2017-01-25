From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 2/2] ovl: properly implement sync_filesystem()
Date: Wed, 25 Jan 2017 19:51:02 +0200
Message-ID: <CAOQ4uxgN=VMQHBfT155S8upa7wF4g-bwNqLT+s225bAZeHkPtg@mail.gmail.com>
References: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
 <1484828008-27507-3-git-send-email-amir73il@gmail.com> <20170124171454.GA31414@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170124171454.GA31414@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jan 24, 2017 at 7:14 PM, Christoph Hellwig <hch@infradead.org> wrote:
> s/sync_filesystem()/->sync_fs/ in the subject?
>

Sure. Thanks.

Just waiting for feedback from Miklos before I decide if I re-post
with or without
 overlay freeze support.

> Otherwise this looks fine to me:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
