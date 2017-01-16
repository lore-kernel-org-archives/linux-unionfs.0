From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 2/6] ovl: check if upperdir fs supports O_TMPFILE
Date: Mon, 16 Jan 2017 15:02:44 +0100
Message-ID: <CAJfpeguX-N0RXrO3oj_ebWPuMPeRcvHn68dx8pO72KdQxthTUQ@mail.gmail.com>
References: <1484488652-611-1-git-send-email-amir73il@gmail.com> <1484488652-611-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1484488652-611-3-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sun, Jan 15, 2017 at 2:57 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> This is needed for choosing between concurrent copyup
> using O_TMPFILE and legacy copyup using workdir+rename.

I'm really wondering if we should constrain upper fs to those that:

 - can do RENAME_EXCHANGE and RENAME_WHITEOUT
 - can do ->tmpfile() which is currently a superset of the above
 - can do xattr, again a superset

The question is whether anybody actually using it with an fs that
doesn't have all of the above.  Because if so, we need to keep
supporting them.  Perhaps we should add warnings about deprecation and
if nobody complains we can remove support for non-conformant fs.

Thanks,
Miklos
