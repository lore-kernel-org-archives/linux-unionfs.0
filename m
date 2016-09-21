From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v3 2/4] ovl: use vfs_clone_file_range() for copy up if
 possible
Date: Wed, 21 Sep 2016 22:57:24 +0100
Message-ID: <20160921215724.GV2356@ZenIV.linux.org.uk>
References: <1473856994-27463-1-git-send-email-amir73il@gmail.com>
 <1473856994-27463-3-git-send-email-amir73il@gmail.com>
 <CAJfpegvtCf7mPanvmhU8vmoyQTUsVo-O0bpNxwnt4abkJ5ZD6Q@mail.gmail.com>
 <CAOQ4uxjEUghU=-RDBOn5zg6hrM1pn1FseEspO8hCLcSnH4WNGA@mail.gmail.com>
 <20160921214814.GC10454@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160921214814.GC10454@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Sep 22, 2016 at 07:48:15AM +1000, Dave Chinner wrote:

> If you get any error other than -EXDEV or -EOPNOTSUPP from a clone
> operation, there's somethign seriously wrong with the metadata of
> the inode or th eunderlying storage.

Such as -ENOSPC?
