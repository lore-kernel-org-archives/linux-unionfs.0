From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC][PATCH v2 4/4] vfs: wrap write f_ops with
        file_{start,end}_write()
Date: Fri, 27 Jan 2017 18:51:47 +0100
Message-ID: <20170127175147.GB18919@lst.de>
References: <1485174742-15866-2-git-send-email-amir73il@gmail.com> <1485200596-14057-1-git-send-email-amir73il@gmail.com> <CAJfpegsL3P-2k=dSWP9XiWKZA3Ywbo0a8TSQ_uS9RkJjqRywRQ@mail.gmail.com> <CAOQ4uxhKFgp3Qhm_TnLrkzSzGkxa4iiOzZ+sejVXLXcCqGPEYg@mail.gmail.com> <CAOQ4uxiVvhkqg5dUjRvvXr1d9K46Wp8yoXg4+abShdH0ae71NA@mail.gmail.com> <CAOQ4uxgiNMt_2yoh4w92GGoHZ1T9dnoCVDhoqe8dX0sKCkpd7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgiNMt_2yoh4w92GGoHZ1T9dnoCVDhoqe8dX0sKCkpd7w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jan 27, 2017 at 07:29:00PM +0200, Amir Goldstein wrote:
> Christoph,
> To your understanding, is it correct to add the IS_REG check in
> vfs_copy_file_range()?

Yes.  The only thing that could maybe make sense would be block devices.
But I'd prefer to only add then on an as-needed basis.
