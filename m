Return-Path: <richard@nod.at>
From: Richard Weinberger <richard@nod.at>
Subject: Re: [EXTERNAL] Re: Copy_up function fail with ubifs on upper layer
Date: Thu, 13 Dec 2018 22:25:45 +0100
Message-ID: <2028730.zAhcSu7C98@blindfold>
In-Reply-To: <D10F1B1F86300941BC976D07C04B3AA0016E5EC6@LOUTCSMB11.napa.ad.etn.com>
References: <D10F1B1F86300941BC976D07C04B3AA0016E4CC7@LOUTCSMB11.napa.ad.etn.com> <18631278.YDA9SCgu4D@blindfold> <D10F1B1F86300941BC976D07C04B3AA0016E5EC6@LOUTCSMB11.napa.ad.etn.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
To: "Guerard, Vincent" <VincentGuerard@eaton.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Am Dienstag, 11. Dezember 2018, 16:32:25 CET schrieb Guerard, Vincent:
> Indeed the patch didn't solve the problem.
> 
> I trigger this every times.
> No power cuts is involved.
> 
> Every time I try to do an operation on a file that hasn't already been copied on the upper layer, it fail when overlayfs try to set xattr. 
> I tried removing the patch in ubifs which cause the fail (https://lore.kernel.org/patchwork/patch/960502/) and everything work now.
> I also just found this patch: https://lore.kernel.org/patchwork/patch/986563/ , so I guess its safe to remove it.

Good, the revert is already upstream.
So, case closed. :-)

Thanks,
//richard
