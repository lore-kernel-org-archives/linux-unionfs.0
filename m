Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 4 Dec 2018 07:21:51 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/11] vfs: copy_file_range needs to strip setuid bits
Message-ID: <20181204152151.GF32245@infradead.org>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203083416.28978-7-david@fromorbit.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, olga.kornievskaia@gmail.com, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

file_remove_privs needs to be called with i_rsem held, which I don't
think we do here.  It also really should be called under the same
i_rwsem critical section that does modify the file content, so we'll
have to move the call into the methods.
