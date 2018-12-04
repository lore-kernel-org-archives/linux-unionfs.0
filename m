Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 4 Dec 2018 07:19:31 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/11] vfs: use inode_permission in copy_file_range()
Message-ID: <20181204151931.GE32245@infradead.org>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203083416.28978-6-david@fromorbit.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, olga.kornievskaia@gmail.com, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

As Darrick already pointed our this looks wrong - for "normal" file
operations, which copy defintively should be we should only allow
write access on a writable fd.
