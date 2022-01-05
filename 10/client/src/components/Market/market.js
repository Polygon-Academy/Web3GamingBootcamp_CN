import { Button,Image,Carousel,Input,Tabs  } from 'antd';
import React,{useState,useEffect,useRef} from 'react';
import './index.css';

import ring1 from '../../assets/ring1.jpg';
import ring2 from '../../assets/ring2.jpg';
import ring3 from '../../assets/ring3.jpg';
import ring4 from '../../assets/ring4.jpg';

const { Search } = Input;
const { TabPane } = Tabs;
const onSearch = value => console.log(value);

function Market(){

    return <div>
      <div className='search'>
        <Search size='large' placeholder="Search items or brands" onSearch={onSearch} style={{ width: 600 }} />
      </div>
      <div className='goods-title'>
        <h2>Explore Things For Her/Him</h2>
        <div>You will have a change to gain exclusive NFT if you buy items on Witness</div>
      </div>
      <div className='goods-list'>
      <Tabs defaultActiveKey="1" centered>
        <TabPane tab="Rings" key="1">
          <div className='goods-item'><img src={ring1}></img><div className='goods-name'>DR</div></div>
          <div className='goods-item'><img src={ring2}></img><div className='goods-name'>Cartier</div></div>
          <div className='goods-item'><img src={ring3}></img><div className='goods-name'>Pandora</div></div>
          <div className='goods-item'><img src={ring4}></img><div className='goods-name'>Arman</div></div>
        </TabPane>
        <TabPane tab="Necklaces" key="2">
          Content of Tab Pane 2
        </TabPane>
        <TabPane tab="Eardrops" key="3">
          Content of Tab Pane 3
        </TabPane>
        <TabPane tab="Bracelet" key="4">
          Content of Tab Pane 3
        </TabPane>
        <TabPane tab="Others" key="5">
          Content of Tab Pane 3
        </TabPane>
      </Tabs>
      </div>
    </div>
    
}
export default Market;