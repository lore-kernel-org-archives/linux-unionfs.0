Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
References: <20181213115717.p7ncktng2ihxw5md@merlin> <20181213121000.GM2217@ZenIV.linux.org.uk>
In-Reply-To: <20181213121000.GM2217@ZenIV.linux.org.uk>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Thu, 13 Dec 2018 13:16:45 +0100
Message-ID: <CACT4Y+Y3Kv6LacRYzZbuNqOAMC7=z-oYUn5aQbN7j-R_JJq6RA@mail.gmail.com>
Subject: Re: [PATCH] fs: Evaluate O_WRONLY | O_RDWR to O_RDWR
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>, syzbot+ae82084b07d0297e566b@syzkaller.appspotmail.com, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, linux-integrity@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Dec 13, 2018 at 1:10 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Thu, Dec 13, 2018 at 05:57:17AM -0600, Goldwyn Rodrigues wrote:
> > A user can open(O_WRONLY | O_RDWR) and the options are valid.
> > However, OPEN_FMODE() evaluates both FMODE_READ and FMODE_WRITE,
> > as negative. We also need to protect the lower layers from this
> > anomaly.
> >
> > Solve it by dropping O_WRONLY, so O_RDWR takes precedence.
>
> Congratulations, you've broken fdutils...  Passing 3 in lower bits
> of open() flags is *not* the same as O_RDWR; behaiviour is
> different and deliberately chosen by existing userland code.
>
> IOW, NAK.

I am eager to hear what it means then.
