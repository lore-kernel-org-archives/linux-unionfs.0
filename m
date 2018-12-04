Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 4 Dec 2018 07:43:47 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/11] vfs: push copy_file_ranges -EXDEV checks down
Message-ID: <20181204154347.GA6925@infradead.org>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203083416.28978-10-david@fromorbit.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, olga.kornievskaia@gmail.com, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Well, this isn't bugfixes anymore, but adding new features..
