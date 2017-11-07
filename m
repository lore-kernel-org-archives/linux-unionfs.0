From: Raphael Hertzog <raphael@ouaza.com>
Subject: Re: Regression in overlayfs in 4.13: "could not fsync file" error by
 PostgreSQL
Date: Tue, 7 Nov 2017 15:32:37 +0100
Message-ID: <20171107143237.yvdrpxbbxyimdofy@home.ouaza.com>
References: <20171103140046.h6oabi5tjqqvj6uj@home.ouaza.com>
 <CAOQ4uxhcWYRcGdwE0QXpZ-_4BFX7LGFyFkFrZSvUgf4PSUFBkg@mail.gmail.com>
 <20171107101125.zwcfd4v3h6pfilhm@home.ouaza.com>
 <CAOQ4uxhLYovF77D6RpdN1LgQsBLRJsuBK6L_aUdncqPgVeE-mA@mail.gmail.com>
 <1510055685.4518.7.camel@kernel.org>
 <CAOQ4uxh5GS+hPRZYcQHD5Q+DnibB181_mvZtOnxvvp8tCNPsAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail.vm.ouaza.com ([212.83.178.2]:48926 "EHLO mail.vm.ouaza.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932844AbdKGOck (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 09:32:40 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh5GS+hPRZYcQHD5Q+DnibB181_mvZtOnxvvp8tCNPsAg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

Hello,

> Wait, I misread the information in the report and I wrongly assumed that
> pg_commit_ts is a file. It is not. it's a directory in which case, the
> inode is an overlay inode and it does have fsync f_op.
> But in the case of a lower directory that has no been copied up (which seems
> to be the case with pg_commit_ts) overlayfs will simple vfs_fsync_range the
> lower dir, so we are back to EINVAL.

Thanks for the explanation, with this understanding I can at least create
an easy work-around (touch a file in the directory, and drop it again,
just before starting postgresql).

> > to not have been be copied up here, when it would have before?
> 
> That is possible, but I would need more information about all the previous
> access to directory pg_commit_ts by postgresql to figure it out.

FWIW I reported this fsync() on a non-modified directory to PostgreSQL
developers here:
https://www.postgresql.org/message-id/20171107135454.lbelbbvfgadljmuj%40home.ouaza.com

Cheers,
-- 
Raphaël Hertzog ◈ Writer/Consultant ◈ Debian Developer

Discover the Debian Administrator's Handbook:
→ https://debian-handbook.info/get/
