From: james harvey <jamespharvey20@gmail.com>
Subject: btrfs subvolume clone or fork (btrfs-progs feature request)
Date: Thu, 25 Jun 2015 16:47:05 -0400
Message-ID: <CA+X5Wn5P2pos=piiujkLHbYR7zCXiANuKrgPT1A1NuqLTh9qMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:34104 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbbFYUrG (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 25 Jun 2015 16:47:06 -0400
Received: by lagx9 with SMTP id x9so52285929lag.1
        for <linux-unionfs@vger.kernel.org>; Thu, 25 Jun 2015 13:47:05 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Request for new btrfs subvolume subcommand:

clone or fork [-i <qgroupid] <source> [<dest>]<name>
   Create a subvolume <name> in <dest>, which is a clone or fork of source.
   If <dest> is not given, subvolume <name> will be created in the
current directory.
   Options
   -i <qgroupid>
      Add the newly created subvolume to a qgroup.  This option can be
given multiple times.

Would (I think):
* btrfs subvolume create <dest-subvolume>
* cp -ax --reflink=always <source-subvolume>/* <dest-subvolume>/
