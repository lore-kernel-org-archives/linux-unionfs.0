Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 13 Dec 2018 12:10:01 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] fs: Evaluate O_WRONLY | O_RDWR to O_RDWR
Message-ID: <20181213121000.GM2217@ZenIV.linux.org.uk>
References: <20181213115717.p7ncktng2ihxw5md@merlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181213115717.p7ncktng2ihxw5md@merlin>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, amir73il@gmail.com, zohar@linux.ibm.com, syzbot+ae82084b07d0297e566b@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com, linux-integrity@vger.kernel.org, linux-unionfs@vger.kernel.org, dvyukov@google.com
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Dec 13, 2018 at 05:57:17AM -0600, Goldwyn Rodrigues wrote:
> A user can open(O_WRONLY | O_RDWR) and the options are valid.
> However, OPEN_FMODE() evaluates both FMODE_READ and FMODE_WRITE,
> as negative. We also need to protect the lower layers from this
> anomaly.
> 
> Solve it by dropping O_WRONLY, so O_RDWR takes precedence.

Congratulations, you've broken fdutils...  Passing 3 in lower bits
of open() flags is *not* the same as O_RDWR; behaiviour is
different and deliberately chosen by existing userland code.

IOW, NAK.
