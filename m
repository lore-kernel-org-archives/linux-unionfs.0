From: james harvey <jamespharvey20@gmail.com>
Subject: btrfs subvolume tree (btrfs-progs feature request)
Date: Thu, 25 Jun 2015 16:47:08 -0400
Message-ID: <CA+X5Wn6RDsNiPXKK8RAkV5y=LqnP3wQWGPdwYYuxZ6kjGdQKjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:36718 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbbFYUrK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 25 Jun 2015 16:47:10 -0400
Received: by lacny3 with SMTP id ny3so52129036lac.3
        for <linux-unionfs@vger.kernel.org>; Thu, 25 Jun 2015 13:47:08 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Request for new btrfs subvolume subcommand:

tree <path>
   Display a depth indented listing of subvolumes present in the
filesystem <path>.

---or---

list ... --tree ...
   ...
   -tree
      display subvolumes in a depth indented listing.

Would (I think):
* Display each top-level subvolume
* Recursively display each subvolume under its parent (using top level
ID against ID)

In the format:
/
=E2=94=9C=E2=94=80=E2=94=80 a
=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 1
=E2=94=9C=E2=94=80=E2=94=80 b
=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 1
=E2=94=82   =E2=94=94=E2=94=80=E2=94=80 2
=E2=94=94=E2=94=80=E2=94=80 c
/other
=E2=94=94=E2=94=80=E2=94=80 d

The actual program "tree" does not work for this application.  It
shows all directories and files, not just the subvolumes.  It has a
"-d" option that only shows directories, which is better, but it still
shows directories that are not subvolumes.

"btrfs subvolume list /" can show 10 lines, with "tree -d" on a
freshly installed system can show over 240,000 lines.

I think it's more likely for btrfs-progs to be able to implement this,
than asking tree to make btrfs-specific code.
