import { createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'
import { state, mutations } from 'store'

const localVue = createLocalVue()
localVue.use(Vuex)

let store = new Vuex.Store({
  state, mutations
})

test('インクリメントを確認', () => {
  store.commit('increment')
  expect(store.state.counter).toBe(1)

  store.commit('increment')
  expect(store.state.counter).toBe(2)
});
