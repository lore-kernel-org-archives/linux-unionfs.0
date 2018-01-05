From: "J . Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH v2 04/17] ovl: decode connected upper dir file handles
Date: Fri, 5 Jan 2018 10:18:20 -0500
Message-ID: <20180105151820.GA28246@fieldses.org>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-5-git-send-email-amir73il@gmail.com>
 <CAOQ4uxhpNCUzcuFSvntAN_JDB=L5NDqZP4m9TxytyO-P6t3F0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:49474 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751487AbeAEPSU (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jan 2018 10:18:20 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhpNCUzcuFSvntAN_JDB=L5NDqZP4m9TxytyO-P6t3F0Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jeff Layton <jlayton@poochiereds.net>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Jan 05, 2018 at 02:33:22PM +0200, Amir Goldstein wrote:
> There. Now you see why I did not want this story in commit message?

No.  I think it's interesting, and might be useful to have around if
someone needs to revisit this decision in the future.  So I'd rather
have it in the changelog or in code comments.  I've had to track down
old mailing list threads for this kind of information in the past and
found it sometimes time-consuming.

--b.
