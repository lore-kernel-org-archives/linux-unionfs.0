From: Josh Boyer <jwboyer@fedoraproject.org>
Subject: Overalyfs regression in 4.0
Date: Wed, 13 May 2015 09:06:26 -0400
Message-ID: <CA+5PVA5uqoJjj24oUT=KMiVfytC7yyRtOggagv-5wUUcgG8iRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33215 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933795AbbEMNG1 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 13 May 2015 09:06:27 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: Vincent Batts <vbatts@gmail.com>, David Howells <dhowells@redhat.com>, linux-unionfs@vger.kernel.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>

Hi Miklos,

Vincent reported[1] what appears to be a regression in Overlayfs with
4.0.  This was found in the upstream docker community[2] on Ubuntu
with 4.0.1 as well, so it is distro agnostic.  The following sequence
of commands in the bug report seems to allow one to remove a non-empty
directory.

Is this expected behavior now?  I looked through the commits in 4.0
and saw a few that might lead to a behavior change, but I am not
familiar enough with Overalyfs to know if this was intentional or not.

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1220915
[2] https://github.com/docker/docker/issues/13108
