From: Richard Weinberger <richard@nod.at>
Subject: Re: [REGRESSION 4.11] Commit d8514d8edb5b ("ovl: copy up regular file
 using O_TMPFILE") breaks ubifs
Date: Thu, 30 Mar 2017 09:18:17 +0200
Message-ID: <fd48872f-cd40-c236-37c4-0ed7d445380a@nod.at>
References: <20170328100107.25095af6@gmail.com>
 <CAOQ4uxisw5vWYsdMTNemw=MqNyS2nxfAUkg+UfoGmbE3-he1Ug@mail.gmail.com>
 <20170328124545.3c4b87ff@gmail.com>
 <CAOQ4uxgNfuLN93owdCUJ=9VcU4DKGVEKkEGT7siiem8quVwCsQ@mail.gmail.com>
 <20170328132818.05871b73@gmail.com>
 <CAOQ4uxiC=RXPwSy7NGt+Ri=Eie4-_WsUPk7Sy-sh9RdrGQuesw@mail.gmail.com>
 <20170328141621.6bb2d639@gmail.com>
 <CAOQ4uxg0xRchsNOh1jtbyEdyDDqV3ToCvo=+QuCsD6duGJU_ZQ@mail.gmail.com>
 <20170329232648.0b5bc1e9@gmail.com>
 <33155efb-2c42-a7e9-b867-06760b1e1495@nod.at>
 <20170330075337.2ab52f3d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from b.ns.miles-group.at ([95.130.255.144]:44723 "EHLO radon.swed.at"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933021AbdC3HSX (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Mar 2017 03:18:23 -0400
In-Reply-To: <20170330075337.2ab52f3d@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org, regressions@leemhuis.info, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, David Oberhollenzer <goliath@sigma-star.at>

Ralph,

Am 30.03.2017 um 07:53 schrieb Ralph Sennhauser:
> With this patch I'm no longer able to reproduce _this_ issue, however,
> rename no longer works either:
> 
>   # mv /etc/config/wireless /etc/config/wireless.back
>   mv: can't rename '/etc/config/wireless': Invalid argument
>   # ls /etc/config/wireless
>   /etc/config/wireless
>   # rm /etc/config/wireless
>   # ls /etc/config/wireless
>   ls: /etc/config/wireless: No such file or directory
> 

Please apply this one too:
http://lists.infradead.org/pipermail/linux-mtd/2017-March/072613.html

Thanks,
//richard
