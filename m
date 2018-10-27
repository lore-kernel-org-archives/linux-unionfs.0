Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35758 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbeJ1Eq4 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 28 Oct 2018 00:46:56 -0400
Date: Sat, 27 Oct 2018 16:04:50 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: overlayfs 4.19: unable to make backup link: Invalid cross-device link
Message-ID: <20181027200450.GA5909@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

I was rebuilding my dropbox Docker container, and it failed in 4.19
with the following error:

dpkg: error processing archive /var/cache/apt/archives/perl-base_5.20.2-3+deb8u11_amd64.deb (--unpack):
 unable to make backup link of `./usr/bin/perl5.20.2' before installing new version: Invalid cross-device link
dpkg-deb: error: subprocess paste was killed by signal (Broken pipe)
dpkg: error: error creating new backup file '/var/lib/dpkg/status-old': Invalid cross-device link
E: Sub-process /usr/bin/dpkg returned an error code (2)

When I booted the 4.18.0-2 kernel from Debian, the exact same Docker
file worked just fine.  With 4.19 it fails reliably.

To reproduce:

git clone https://github.com/tytso/docker-dropbox
cd docker-dropbox
docker build --no-cache .

I'm using a Debian testing (buster) userspace, using the docker-ce
from dropbox.com, version 18.03.1~ce-0~debian, using overlay2 storage
driverh.

Does this ring a bell at all?  Can someone give me some tips on how to
troubleshoot this?

Thanks!!

     	       	      	       	   - Ted
