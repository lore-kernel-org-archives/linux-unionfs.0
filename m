From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Regression in handling power cuts since 3a1e819b4e80 ("ovl: store
 file handle of lower inode on copy up")
Date: Fri, 19 Oct 2018 18:07:52 +0300
Message-ID: <CAOQ4uxiLKcx6g8v873LzrWNuSRw-KaqUC59BOJvtskJEwhLvGw__40632.0054120899$1539961622$gmane$org@mail.gmail.com>
References: <CACna6rx3YBNYKGu7T-J2J-S_3yr-oafJf3pL5TbGDFRzU6dihg@mail.gmail.com>
 <1457198086.5374.1539960353710.JavaMail.zimbra@nod.at>
 <11759557.52cTf2r1oB@blindfold>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <11759557.52cTf2r1oB@blindfold>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Richard Weinberger <richard@nod.at>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-mtd@lists.infradead.org, russell@personaltelco.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, openwrt-devel@lists.openwrt.org
List-Id: linux-unionfs@vger.kernel.org

On Fri, Oct 19, 2018 at 5:59 PM Richard Weinberger <richard@nod.at> wrote:
>
> Am Freitag, 19. Oktober 2018, 16:45:53 CEST schrieb Richard Weinberger:
> > Well, I fear it uncovers a problem in UBIFS. We had already problems with overlayfs.
> > Did you bisect the problem and you are sure that the said commit is the first bad commit?
>
> Another thing, UBIFS has no export operations, so overlayfs will fall back to xattrs,
> if I read the commit correctly.
> Maybe this is the root of the problem.
>

You are not reading the commit correctly.

Commit says:
    "If lower fs does not support NFS export ops store a zero sized xattr so we
    can always use the overlay.origin xattr to distinguish between a copy up
    and a pure upper inode."

What it means is:
- Doesn't matter if ubifs supports NFS export - it's not the lower fs
- squashfs supports NFS export, but has zero s_uuid, so currently that
  is treated the same as no NFS export support (I have patch to relax this)
- The result of no lower NFS export support is that a zero size xattr is written
  as opposed to non-zero size xattr in the case of lower support NFS export

Thanks,
Amir.

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
