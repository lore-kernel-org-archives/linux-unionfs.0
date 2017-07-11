From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [bug report] ovl: introduce the inodes index dir feature
Date: Tue, 11 Jul 2017 10:37:21 +0300
Message-ID: <20170711073721.wwaovemvvonxhja4@mwanda>
References: <20170710141611.wlz2rsoul4v43bi6@mwanda>
 <CAOQ4uxgrbbRj2mB6gNz_DRMbcctYFb-xSk_f53UkwCfF-3pEew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41442 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755246AbdGKHhd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 11 Jul 2017 03:37:33 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgrbbRj2mB6gNz_DRMbcctYFb-xSk_f53UkwCfF-3pEew@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Jul 10, 2017 at 07:15:47PM +0300, Amir Goldstein wrote:
> >   1064
> >   1065                  if (ufs->indexdir) {
> >                             ^^^^^^^^^^^^^
> > We check for NULL here so the code so that's OK except what do we want to
> > set the error code to if ovl_workdir_create() fails?  Right now it's
> > set to a random pointer casted to int.
> 
> I don't follow.
> If ovl_workdir_create() fails, ufs->indexdir will be NULL and err will be 0.
> If it succeeds err will be set here below.
> 

Oh, yeah.  You're right.  My bad.

regards,
dan carpenter
