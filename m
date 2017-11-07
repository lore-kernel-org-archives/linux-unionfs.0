From: Raphael Hertzog <raphael@ouaza.com>
Subject: Re: Regression in overlayfs in 4.13: "could not fsync file" error by
 PostgreSQL
Date: Tue, 7 Nov 2017 17:30:53 +0100
Message-ID: <20171107163053.mdl43futffgz53a5@home.ouaza.com>
References: <20171103140046.h6oabi5tjqqvj6uj@home.ouaza.com>
 <CAOQ4uxhcWYRcGdwE0QXpZ-_4BFX7LGFyFkFrZSvUgf4PSUFBkg@mail.gmail.com>
 <20171107101125.zwcfd4v3h6pfilhm@home.ouaza.com>
 <CAOQ4uxhLYovF77D6RpdN1LgQsBLRJsuBK6L_aUdncqPgVeE-mA@mail.gmail.com>
 <1510055685.4518.7.camel@kernel.org>
 <CAOQ4uxh5GS+hPRZYcQHD5Q+DnibB181_mvZtOnxvvp8tCNPsAg@mail.gmail.com>
 <20171107143237.yvdrpxbbxyimdofy@home.ouaza.com>
 <CAOQ4uxh3QsXXYycY9RnOm=46EJ7Oa+4F=mUjGUiC3YeRTQyemQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail.vm.ouaza.com ([212.83.178.2]:50987 "EHLO mail.vm.ouaza.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934671AbdKGQaz (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 11:30:55 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh3QsXXYycY9RnOm=46EJ7Oa+4F=mUjGUiC3YeRTQyemQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

Le mardi 07 novembre 2017, Amir Goldstein a écrit :
> > FWIW I reported this fsync() on a non-modified directory to PostgreSQL
> > developers here:
> > https://www.postgresql.org/message-id/20171107135454.lbelbbvfgadljmuj%40home.ouaza.com
> 
> I guess regardless of what overlayfs behavior should be, PostgreSQL
> developers better fix this somehow otherwise postgress upgrade is going to
> break for users with stable kernel.

Given the current set of answers, it seems unlikely that PostgreSQL will
stop doing those fsync() calls on unmodified directories because it's hard
for them to track whether the directory is dirty or not but it might start
to ignore EINVAL/EROFS errors on those fsync calls.

That said I don't think that the number of persons using PostgreSQL on top
of overlayfs is so important that they are worried about this breakage
pattern on upgrade...

Cheers,
-- 
Raphaël Hertzog ◈ Writer/Consultant ◈ Debian Developer

Discover the Debian Administrator's Handbook:
→ https://debian-handbook.info/get/
