From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v3 2/4] ovl: use vfs_clone_file_range() for copy up if possible
Date: Fri, 30 Sep 2016 13:14:55 +0200
Message-ID: <CAJfpegvFeOuY7o_m+P93mDdvBs5GquqOwauqENTqZ3MOaR0K0A@mail.gmail.com>
References: <1473856994-27463-1-git-send-email-amir73il@gmail.com>
 <1473856994-27463-3-git-send-email-amir73il@gmail.com> <CAJfpegvtCf7mPanvmhU8vmoyQTUsVo-O0bpNxwnt4abkJ5ZD6Q@mail.gmail.com>
 <CAOQ4uxjEUghU=-RDBOn5zg6hrM1pn1FseEspO8hCLcSnH4WNGA@mail.gmail.com>
 <CAJfpegsmc5a5=X11OZZ2__ghOBbe4kdWge10EFBEAG+ftrGGJQ@mail.gmail.com> <CAOQ4uxhht5OFOxypn-0LzwaVSqsQPNo0rTsdWp-ubzvw0a=1PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxhht5OFOxypn-0LzwaVSqsQPNo0rTsdWp-ubzvw0a=1PQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Sep 29, 2016 at 11:00 AM, Amir Goldstein <amir73il@gmail.com> wrote:

> Will you be able to queue v4 patches for 4.9?

Queued to

 git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git #overlayfs-next

Thanks,
Miklos
