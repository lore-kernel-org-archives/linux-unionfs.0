From: Ignacy =?iso-8859-2?Q?Gaw=EAdzki?=
	<ignacy.gawedzki@green-communications.fr>
Subject: [PATCH v2 0/1] OverlayFS: Fix checking permissions during lookup.
Date: Wed, 24 Feb 2016 14:55:43 +0100
Message-ID: <20160224135543.GA8422@zenon.in.qult.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from str75-3-78-193-33-39.fbxo.proxad.net ([78.193.33.39]:47434 "EHLO
	mail.qult.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbcBXNzs (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 24 Feb 2016 08:55:48 -0500
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

I just realized that the patch sent previously regarding this issue is
bogus.

Here's the proper patch for your kind consideration.

Cheers,

Ignacy

Ignacy Gaw=EAdzki (1):
  OverlayFS: Fix checking permissions during lookup.

 fs/namei.c            | 29 +++++++++++++++++++++++++----
 fs/overlayfs/super.c  |  2 +-
 include/linux/namei.h |  1 +
 3 files changed, 27 insertions(+), 5 deletions(-)

--=20
2.5.0
